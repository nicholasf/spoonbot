
defmodule Bridge.IRC do
  use GenServer.Behaviour

  def run() do
    { server, port, nickname } = Enum.at(config, 0)
    { :ok, socket } = :gen_tcp.connect(:erlang.binary_to_list(server), port, [:binary, {:active, false}])
    :ok = transmit(socket, "NICK #{nickname}")
    :ok = transmit(socket, "USER #{nickname} #{server} spoonbot :spoonbot")
    do_listen(socket)
  end

  def do_listen(socket) do
    ping      = ~r/\APING/
    motd_end  = ~r/\/MOTD/
    msg       = ~r/PRIVMSG spoonbot/
    { channel_name  } = channel
    { :ok, invoker }  = Regex.compile("PRIVMSG #{channel_name} :spoonbot:")

    case :gen_tcp.recv(socket, 0) do
      { :ok, data } ->
        IO.puts data

        if Regex.match?(motd_end, data), do: join_channel(socket)
        if Regex.match?(ping, data), do: pong(socket, data)

        if Regex.match?(invoker, data) do
          IO.puts "invoker  ... "
          bits = String.split(data, ~r/:spoonbot:/)
          phrase = String.strip(Enum.at bits, 1)
          command = Commands.find(phrase)
          if command do
            { phrase, func } = command
            result = func.()
            say(socket, result)
          end
        end

        # if Regex.match?(msg, data) do
        #   IO.puts "msg ... "
        # end

        do_listen(socket)
      { :error, :closed } ->
        IO.puts "The client closed the connection..."
    end
  end

  def transmit(socket, msg) do
    IO.puts "sending #{msg}"
    :gen_tcp.send(socket, "#{msg} \r\n")
  end

  def say(socket, msg) do
    responder = fn
      { channel } -> transmit(socket, "PRIVMSG #{channel} :#{msg}")
      { channel, password } -> transmit(socket, "PRIVMSG #{channel} :#{msg}")
    end

    IO.inspect channel
    responder.(channel)
  end

  def join_channel(socket) do
    joiner = fn
      { channel } ->  transmit(socket, "JOIN #{ channel }")
      { channel, password } -> transmit(socket, "JOIN #{ channel } #{ password }")
    end

    joiner.(channel)
  end

  def pong(socket, data) do
    server = Enum.at(Regex.split(~r/\s/, data), 1)
    transmit(socket, "PONG #{ server }")
  end

  def config do
    { :ok, config} = :application.get_env(:spoonbot, :conf )
    config
  end

  def channel do
    Enum.at(config, 1)
  end
end
