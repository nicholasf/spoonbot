defmodule Spoonbot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = []
    opts = [strategy: :one_for_one, name: Spoonbot.Supervisor]

    Commands.start_link
    spawn(Bridge.IRC, :run, [])
    Code.require_file("spoonbot.exs")

    Supervisor.start_link(children, opts)
  end

  def command(phrase, func) do
      Commands.add({ phrase, func })
  end
end
