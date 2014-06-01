# defmodule CommandHandler do
#   def invoke_command(command, data) do
#     atom = command[:atom]
#     arity = command[:arity]
#     module = command[:module]
#     str = apply(module, atom, [data])
#     SpoonResponse.new(msg: str)
#   end
# end
