defmodule ComandsTest do
  use ExUnit.Case

  # setup_all do 
  #   Commands.start_link
  # end

  test "add and find" do
    Commands.add({ ~r/test/, &(&1) })
    { regex, text } = Commands.find("test")
    assert text = "test"
  end
end
