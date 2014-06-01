defmodule Spoonbot do
  use Application.Behaviour

  def start(_type, _args) do
    #1 load the spoonbot.exs file
    code = Code.require_file("spoonbot.exs")
    IO.inspect code
    # irc_pid = spawn(Bridge.IRC, :run, [])
    Commands.start_link
    Spoonbot.Supervisor.start_link
  end

  defmacro command(phrase, func) do
    Commands.add({ phrase, func })
  end

  defmodule Commands do
    @name { :global, __MODULE__ }

    def start_link do
      Agent.start_link( fn-> HashDict.new end, name: @name )
    end 

    def add(command) do
      Agent.update(@name, &add_command(&1, command))
    end

    def find(phrase) do
      Agent.get(@name, &Dict.get(&1, phrase))
    end

    defp add_command(dict, command) do
      Dict.put(dict, elem(command, 0), command)
    end
  end
end
