defmodule Spoonbot do
  use Application.Behaviour

  def start(_type, _args) do
    Commands.start_link
    spawn(Bridge.IRC, :run, [])
    code = Code.require_file("spoonbot.exs")
    Spoonbot.Supervisor.start_link
  end

  defmacro command(phrase, func) do
    quote do
      Commands.add({ unquote(phrase), unquote(func) })
    end
  end
end
