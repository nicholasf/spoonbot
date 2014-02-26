defmodule Spoonbot do
  use Application.Behaviour
  import CommandBuilder

  def start(_type, _args) do
    commands = build([Info])
    irc_pid = spawn(Bridge.IRC, :run, [commands])
    # http_pid = spawn(Bridge.HTTP, :run, [vocab])

    Spoonbot.Supervisor.start_link
  end
end

defrecord SpoonCommand, pattern: nil, cmd: nil

defrecord SpoonResponse, msg: nil

