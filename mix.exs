defmodule Spoonbot.Mixfile do
  use Mix.Project

  def project do
    [ app: :spoonbot,
      version: "0.0.1",
      elixir: ">= 0.13.3",
      deps: deps ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [ applications: [],
      mod: { Spoonbot, [] }
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
