# Spoonbot

Spoonbot isn't ready for general use yet.

## Design Overview for basic functionality (1.0.0)

A spoonbot will use a configuration layer to wire together Bridges (methods of delivery) with nominated command modules.

Any command should be able to work with any bridge.

## Lifecycle

Spoonbot.ex will

* start up via 'mix run --no-halt'.
* read in a config for bridges use and command modules to load
* create a list of commands from the command modules
* spawn a process for each bridge via its run(commands) function


### Bridges

Are regular protocol interfaces like IRC, HTTP, Twitter, etc.. They each support a run(commands) function.

Bridges know how to listen for commands via a Regex match to the pattern property in each command. They then pass the matching command into the CommandHandler and receive a string result, which they then use as a response suitable for their protocol.

### Command Modules

Are regular Elixir Modules supporting a single var args list of arguments:

```
defmodule Info do
  def version(data) do
   "My version is: #{System.version()}"
  end
end
```

Each function should return a string for use in bridges.

At the moment commands cannot support rich language - 'what is time spoonbot?', etc.. Whether this is problematic or not, Im unsure.

### Testing

We need to come up with a testing strategy, particularly on how to run tests for bridges and commands together.

* command tests should be simple, as they are functions that run in isolation and return strings.
* bridge tests need some thought.

To run the current test(s) use:

```
mix run --no-start
```

## Roadmap

* finalize basic structure and write tests
* consider command rich language feature, perhaps by module attributes. Try to avoid macros.
* consider OTP.
* consider location transparency and bot networks.
