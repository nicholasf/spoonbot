ExUnit.start

defmodule InfoTest do
  use ExUnit.Case, async: true


  test "it returns the elixir version" do
    assert Info.version([]) == "My version is: #{System.version()}"
  end
end
