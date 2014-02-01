#A simple, one server, multiple channels IRC bridge.

defmodule Bridge.IRC do
  use GenServer.Behaviour
  @moduledoc false

  defimpl Robot, for: RobotResponse do

    def speak(robot_response) do
      IO.puts robot_response.msg
    end

  end

  @doc """
    ## Config

    A list of tuples containing server, nick_name, channel, channel_password

  """
  def run() do
    {:ok, config} = :application.get_env(:spoonbot, :conf)
    {server, port, nickname} = Enum.at(config, 0)
    channel_list = Enum.at(config, 1)

    {:ok, socket} = :gen_tcp.connect(:erlang.binary_to_list(server), port, [:binary, {:active, false}])
    :ok = transmit(socket, "NICK #{nickname}")
    :ok = transmit(socket, "USER #{nickname} #{server} spoonbot :spoonbot")
    do_listen socket, channel_list
  end

  def do_listen(socket, channel_list) do
    ping      = %r/\APING/
    motd_end  = %r/\/MOTD/

    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        IO.puts "#{data}"

        if Regex.match?(motd_end, data), do: join(socket, "JOIN #polyhack")
        if Regex.match?(ping, data), do: pong(socket, data)

        do_listen(socket)
      {:error, :closed} ->
        IO.puts "The client closed the connection..."
    end
  end

  def transmit(socket, msg) do
    IO.puts "sending #{msg}"
    :gen_tcp.send(socket, "#{msg} \r\n")
  end

  def join(socket, channels) do

    transmit(socket, "JOIN #polyhack")
  end

  def pong(socket, data) do
    server = Enum.at(Regex.split(%r/\s/, data), 1)
    transmit(socket, "PONG #{server}")
  end
end


