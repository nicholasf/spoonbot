defmodule Commands do
    @name { :global, __MODULE__ }

    def start_link do
        Agent.start_link( fn-> [] end, name: @name )
    end 

    def add(command) do
        Agent.update(@name, &add_command(&1, command))
    end

    def find(phrase) do
        command_list = Agent.get(@name, &(&1))
        Enum.find(command_list, fn ({ pattern, func }) -> Regex.match?(pattern, phrase) end) 
    end

    defp add_command(list, command) do
        [command | list]
    end
end
