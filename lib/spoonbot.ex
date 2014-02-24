defmodule Spoonbot do
  use Application.Behaviour

  def start(_type, _args) do
    command_modules = [ExampleCommand, Info]

    loader = fn(module) ->
      signatures = module.__info__(:functions)
      Enum.map(signatures,
        fn(signature) -> [{ signature, module.__info__(:module) }] end)
    end

    metas = Enum.map(command_modules, loader)
    metas = List.flatten metas

    vocab_loader = fn(meta) ->
      signature = elem meta, 0
      module = elem meta, 1
      atom = elem(signature, 0)
      name = atom_to_binary elem(signature, 0)
      pattern = ~r/#{name}/ #consider calling Regex.escape/1 here
      arity = elem(signature, 1)
      HashDict.new([module: module, pattern: pattern, atom: atom, arity: arity])
    end

    vocab = Enum.map(metas, vocab_loader)
    irc_pid = spawn(Bridge.IRC, :run, [vocab])
    # http_pid = spawn(Bridge.HTTP, :run, [vocab])

    Spoonbot.Supervisor.start_link
  end
end

defrecord SpoonCommand, pattern: nil, cmd: nil

defrecord SpoonResponse, msg: nil

defmodule ExampleCommand do
  def hello(data) do
    "hello"
  end

  def goodbye(data) do
    "goodbye"
  end
end

defmodule Info do
  def version(data) do
   "My version is: #{System.version()}"
  end
end
