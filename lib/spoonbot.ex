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

  defmacro command(phrase, func) do
    quote do
      Commands.add({ unquote(phrase), unquote(func) })
    end
  end
end
