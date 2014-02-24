
#A simple, one server, multiple channels IRC bridge.

# defprotocol Speaker do
#   def speak(spoon_response)
# end

# defimpl Speaker, for: SpoonResponse do
#   def speak(spoon_response) do
#     IO.puts(spoon_response.msg)
#     Bridge.IRC.say(socket, spoon_response.msg)
#   end
# end

defmodule Bridge.IRC do
  use GenServer.Behaviour
  import CommandHandler
  @moduledoc false

  def run(vocab) do
    { :ok, config } = :application.get_env(:spoonbot, :conf)
    { server, port, nickname } = Enum.at(config, 0)

    { :ok, socket } = :gen_tcp.connect(:erlang.binary_to_list(server), port, [:binary, {:active, false}])
    :ok = transmit(socket, "NICK #{nickname}")
    :ok = transmit(socket, "USER #{nickname} #{server} spoonbot :spoonbot")
    do_listen(socket, vocab)
  end

  def do_listen(socket, vocab) do
    ping      = ~r/\APING/
    motd_end  = ~r/\/MOTD/
    msg       = ~r/PRIVMSG spoonbot/

    case :gen_tcp.recv(socket, 0) do
      { :ok, data } ->
        IO.puts "#{data}"

        if Regex.match?(motd_end, data), do: join(socket)
        if Regex.match?(ping, data), do: pong(socket, data)

        if Regex.match?(msg, data) do
          command = Enum.find(vocab, fn(command) ->
            pattern = command[:pattern]
            Regex.match?(pattern, data)
          end)

          if command do
            spoon_response = invoke_command(command, data)
            IO.inspect spoon_response
            IO.puts spoon_response.msg
            say(socket, spoon_response.msg)
          end
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

