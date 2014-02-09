#A simple, one server, multiple channels IRC bridge.

defmodule Bridge.IRC do
  use GenServer.Behaviour
  @moduledoc false

  defimpl Robot, for: RobotResponse do

    def speak(robot_response) do
      IO.puts robot_response.msg
    end

  end

  def run(vocab) do
    { :ok, config } = :application.get_env(:spoonbot, :conf)
    { server, port, nickname } = Enum.at(config, 0)

    { :ok, socket } = :gen_tcp.connect(:erlang.binary_to_list(server), port, [:binary, {:active, false}])
    :ok = transmit(socket, "NICK #{nickname}")
    :ok = transmit(socket, "USER #{nickname} #{server} spoonbot :spoonbot")
    do_listen(socket, vocab)
  end

  def do_listen(socket, vocab) do
    ping      = %r/\APING/
    motd_end  = %r/\/MOTD/
    msg       = %r/PRIVMSG spoonbot/

    case :gen_tcp.recv(socket, 0) do
      { :ok, data } ->
        IO.puts "#{data}"

        if Regex.match?(motd_end, data), do: join(socket)
        if Regex.match?(ping, data), do: pong(socket, data)

        if Regex.match?(msg, data) do
          matched_command = Enum.find(vocab, fn(command) -> Regex.match?(command.pattern, data) end)
          say(socket, matched_command)
        end

        do_listen(socket, vocab)
      { :error, :closed } ->
        IO.puts "The client closed the connection..."
    end
  end

  def transmit(socket, msg) do
    IO.puts "sending #{msg}"
    :gen_tcp.send(socket, "#{msg} \r\n")
  end

  #needs to become channel aware
  def say(socket, msg) do
    transmit(socket, "PRIVMSG #cbt hello ..")
  end

  def join(socket) do
    { :ok, config} = :application.get_env(:spoonbot, :conf )
    channel_list = Enum.at(config, 1)

    joiner = fn
      { channel } -> transmit(socket, "JOIN #{channel}")
      { channel, password } -> transmit(socket, "JOIN #{channel} #{password}")
    end

    Enum.each(channel_list, joiner)
  end

  def pong(socket, data) do
    server = Enum.at(Regex.split(%r/\s/, data), 1)
    transmit(socket, "PONG #{server}")
  end
end

