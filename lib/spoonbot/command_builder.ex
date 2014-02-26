defmodule CommandBuilder do

  def build(module_list) do
    loader = fn(module) ->
      signatures = module.__info__(:functions)
      Enum.map(signatures,
        fn(signature) -> [{ signature, module.__info__(:module) }] end)
    end

    metas = Enum.map(module_list, loader)
    metas = List.flatten metas

    command_loader = fn(meta) ->
      signature = elem meta, 0
      module = elem meta, 1
      atom = elem(signature, 0)
      name = atom_to_binary elem(signature, 0)
      pattern = ~r/#{name}/ #consider calling Regex.escape/1 here
      arity = elem(signature, 1)
      HashDict.new([module: module, pattern: pattern, atom: atom, arity: arity])
    end

    Enum.map(metas, command_loader)
  end
end
