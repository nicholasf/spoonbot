defmodule Spoonbot.Mixfile do
  use Mix.Project

  def project do
    [ app: :spoonbot,
      version: "0.0.1",
      elixir: "~> 0.12.3-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ mod: { Spoonbot, [] },
      env: [ conf: [ { "irc.freenode.org", 6667, "spoonbot" }, [ { "#polyhack" }, { "#cbt", "jifasnif" } ]] ]
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
