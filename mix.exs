defmodule Spoonbot.Mixfile do
  use Mix.Project

  def project do
    [ app: :spoonbot,
      version: "0.0.1",
      elixir: "~> 0.13.3",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ mod: { Spoonbot, [] },
      env: [ conf: [ { "banks.freenode.net", 6667, "spoonbot" }, { "#nftest" } ] ]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    []
  end
end
