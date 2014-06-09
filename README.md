Spoonbot - an IRC bot written in Elixir with a simple command syntax.

## Install

You will need Elixir 0.13.3 or more recent installed. See http://elixir-lang.org/getting_started/1.html

## Make your own

Clone spoonbot's repo.

Open config/config.exs 

```
[ spoonbot: 
    [ conf: [ { "banks.freenode.net", 6667, "spoonbot" }, { "#polyhack" } ] ] 
]

```
Configure the conf variable with the address of the IRC server, its port, the client name, and the connected channel.

Start your bot.

```
elixir --sname spoonbot -S mix run --no-halt
```

When the bot appears in the channel speak to it:

```
4:09 PM <•nicholasf> spoonbot: heya
4:09 PM <spoonbot> aight nicholasf

```

Open spoonbot.exs and see how you can write Spoonbot commands.

```
import Spoonbot

command "pattern", fn(speaker) -> 
    #logic
    #return a string holding the bot's response
end
```
The simplest command takes a phrase for recognition then, followed by a comma, an anonymous function 
with one argument - the name of the speaker in the IRC chatroom. It should return a string to appear in the chatroom.

If you want to parse the bot's input pass in a string that can be compiled into a Regex. Then your function will take two arguments, the second for the arguments parsed from the regex.

```
command "say (.*)", fn (speaker, args) -> 
    Enum.at(args, 0) 
end
```

```
6:45 PM <nicholasf> spoonbot: say something or other
6:45 PM <spoonbot> something or other
````

Connect to the running spoonbot Erlang Node and hot load a new command remotely.

```
♪  spoonbot git:(master) ✗ iex --sname bark
Erlang/OTP 17 [erts-6.0] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (0.13.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(bark@argo)1> Node.connect :spoonbot@argo
true
(bark@argo)2> c "lib/spoonbot/commands.ex"
[Commands]
iex(bark@argo)3> import Commands
nil
iex(bark@argo)4> command "mirror me", &(String.reverse(&1))
:ok

```

The command will be ready in the bot. 

Add more commands in spoonbot.exs or build your own exs file and parse it in the remote node:

```
iex(bark@argo)4> Code.require_file("alternate_commands.exs") 
```
