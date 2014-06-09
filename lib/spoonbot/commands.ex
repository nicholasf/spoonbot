defmodule Commands do
    @name { :global, __MODULE__ }

    def start_link do
        Agent.start_link( fn-> HashSet.new end, name: @name )
    end 

    def add(command) do
        Agent.update(@name, &Set.put(&1, command))
    end

    def find(phrase) do
        set = Agent.get(@name, &(&1))
        Enum.find(set, fn ({ pattern, func }) -> Regex.match?(pattern, phrase) end) 
    end
end
