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
