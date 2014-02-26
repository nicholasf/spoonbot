
defmodule Bridge.IRC do
  use GenServer.Behaviour
  import CommandHandler
  @moduledoc false

  def run(commands) do
    { :ok, config } = :application.get_env(:spoonbot, :conf)
    { server, port, nickname } = Enum.at(config, 0)

    { :ok, socket } = :gen_tcp.connect(:erlang.binary_to_list(server), port, [:binary, {:active, false}])
    :ok = transmit(socket, "NICK #{nickname}")
    :ok = transmit(socket, "USER #{nickname} #{server} spoonbot :spoonbot")
    do_listen(socket, commands)
  end

  def do_listen(socket, commands) do
    ping      = ~r/\APING/
    motd_end  = ~r/\/MOTD/
    msg       = ~r/PRIVMSG spoonbot/

    case :gen_tcp.recv(socket, 0) do
      { :ok, data } ->
        IO.puts "#{data}"

        if Regex.match?(motd_end, data), do: join(socket)
        if Regex.match?(ping, data), do: pong(socket, data)

        if Regex.match?(msg, data) do
          command = Enum.find(commands, fn(command) ->
            pattern = command[:pattern]
            Regex.match?(pattern, data)
          end)

          if command do
            spoon_response = invoke_command(command, data)
            say(socket, spoon_response.msg)
          end
        end

        do_listen(socket, commands)
      { :error, :closed } ->
        IO.puts "The client closed the connection..."
    end
  end

  def transmit(socket, msg) do
    IO.puts "sending #{msg}"
    :gen_tcp.send(socket, "#{msg} \r\n")
  end

  def say(socket, msg) do
    { :ok, config} = :application.get_env(:spoonbot, :conf )
    channel_list = Enum.at(config, 1)
    responder = fn
      { channel } -> transmit(socket, "PRIVMSG #{channel} :#{msg}")
      { channel, password } -> transmit(socket, "PRIVMSG #{channel} :#{msg}")
    end

    Enum.each(channel_list, responder)
  end

  #needs to become channel aware
  # def raw_say(socket, data) do
  #   pieces = String.split(data, ":")
  #   phrase = Enum.drop(pieces, 2)
  #   IO.puts("Saying: #{phrase}")

  #   transmit(socket, "PRIVMSG #cbt :#{phrase}")
  # end

  def join(socket) do
    { :ok, config} = :application.get_env(:spoonbot, :conf )
    channel_list = Enum.at(config, 1)

    joiner = fn
      { channel } -> transmit(socket, "JOIN #{ channel }")
      { channel, password } -> transmit(socket, "JOIN #{ channel } #{ password }")
    end

    Enum.each(channel_list, joiner)
  end

  def pong(socket, data) do
    server = Enum.at(Regex.split(~r/\s/, data), 1)
    transmit(socket, "PONG #{ server }")
  end
end

