defmodule Commands do
    @name { :global, __MODULE__ }

    def start_link do
        Agent.start_link( fn-> HashDict.new end, name: @name )
    end 

    def add(command) do
        Agent.update(@name, &add_command(&1, command))
    end

    def find(phrase) do
        dict = Agent.get(@name, &(&1))
        list = Dict.values dict
        Enum.find(list, fn ({ pattern, func }) -> Regex.match?(pattern, phrase) end) 
    end

    defp add_command(dict, command) do
        Dict.put(dict, elem(command, 0), command) 
    end
end
