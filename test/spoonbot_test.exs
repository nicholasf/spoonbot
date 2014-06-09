defmodule SpoonbotTest do 
  use ExUnit.Case

  test "the command function" do
    Spoonbot.command "test", &(&1)
    { _, func } = Commands.find("test")
    assert func.("test") == "test"
  end
end