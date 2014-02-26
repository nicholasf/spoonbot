ExUnit.start

defmodule CommandBuilderTest do
  use ExUnit.Case, async: true


  test "it creates a tuple structure from the Info module and its function" do
    commands = CommandBuilder.build([Info])
    command = Enum.at commands, 0
    assert command[:module] == Info
  end


  #the below is left for identifying a potential problem with inner modules

  # defmodule TestCommand do
  #   def test_command do
  #     "hello"
  #   end
  # end

  # test "a possible bug when dealing with inner modules? " do
  #   commands = CommandBuilder.build([CommandBuilderTest.TestModule])
  #   commands = CommandBuilder.build([Info])
  #   command = Enum.at commands, 0
  #   assert command[:module] == CommandBuilderTest.TestModule
  # end

  # 1) test a possible bug when dealing with inner modules?  (CommandBuilderTest)
  #    ** (UndefinedFunctionError) undefined function: CommandBuilderTest.TestModule.__info__/1
  #    stacktrace:
  #      CommandBuilderTest.TestModule.__info__(:functions)
  #      lib/spoonbot/command_builder.ex:5: anonymous fn/1 in CommandBuilder.build/1
  #      (elixir) lib/enum.ex:875: Enum."-map/2-lc$^0/1-0-"/2
  #      lib/spoonbot/command_builder.ex:10: CommandBuilder.build/1
  #      test/command_builder_test.exs:21: CommandBuilderTest."test a possible bug when dealing with inner modules? "/1


end
