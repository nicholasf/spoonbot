
defmodule Bridge.IRC do

  def run() do
    { server, port, nickname } = Enum.at(config, 0)
    { :ok, socket } = :gen_tcp.connect(:erlang.binary_to_list(server), port, [:binary, {:active, false}])
    :ok = transmit(socket, "NICK #{nickname}")
    :ok = transmit(socket, "USER #{nickname} #{server} #{bot_name} :#{bot_name}")
    do_listen(socket)
  end

  def do_listen(socket) do
    ping      = ~r/\APING/
    motd_end  = ~r/\/MOTD/
    msg       = ~r/PRIVMSG spoonbot/
    { channel_name  } = channel
    { :ok, invoker }  = Regex.compile("PRIVMSG #{channel_name} :#{bot_name}:")

    case :gen_tcp.recv(socket, 0) do
      { :ok, data } ->
        IO.puts data

        if Regex.match?(motd_end, data), do: join_channel(socket)
        if Regex.match?(ping, data), do: pong(socket, data)

        if Regex.match?(invoker, data) do
          bits = String.split(data, ":#{bot_name}:")
          phrase = String.strip(Enum.at bits, 1)
          command = Commands.find(phrase)
          if command do
            { pattern, func } = command
            args = Regex.scan(pattern, phrase, capture: :all_but_first)
            speaker_name = speaker(Enum.at bits, 0)
            args = Enum.filter(args, &((Enum.count &1) > 0))

            if (Enum.count(args) > 0) do
              result = func.(speaker_name, Enum.at(args, 0))
            else
              result = func.(speaker_name)
            end

            say(socket, result)
          end
        end

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
    { :ok, config } = :application.get_env(:spoonbot, :conf)
    config
  end

  def bot_name do
    { _, _, name } = Enum.at(config, 0)
    name
  end

  def channel do
    Enum.at(config, 1)
  end

  def speaker(irc_fragment) do
    bits = String.split(irc_fragment, "!")
    str = Enum.at bits, 0
    String.slice(str, 1..-1)
  end
end
