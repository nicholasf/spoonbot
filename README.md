Spoonbot - an IRC bot written in Elixir with a simple command syntax.

## Install

You will need Elixir 0.13.3 or more recent installed. See http://elixir-lang.org/getting_started/1.html

## Make your own

1. Clone spoonbot's repo.

2. Open config/config.exs 

```
[ spoonbot: 
    [ conf: [ { "banks.freenode.net", 6667, "spoonbot" }, { "#polyhack" } ] ] 
]

```

Replace the "spoonbot" string with the name of your bot. Replace the "#polyhack" string with the IRC channel you wish your bot to live in.

3. Start your bot.

```
elixir --sname spoonbot -S mix run --no-halt
```

4. When the bot appears in the channel speak to it:

```
4:09 PM <•nicholasf> spoonbot: heya
4:09 PM <spoonbot> aight nicholasf

```

5. Open spoonbot.exs and see how you can write simple Spoonbot commands.

```
import Spoonbot

command "pattern", fn(speaker) -> 
    #logic
    #return a string holding the bot's response
end
```
A command takes a phrase for recognition then, followed by a comma, an anonymous function 
with one argument - the name of the speaker in the IRC chatroom. It should return a string to appear in the chatroom.


6. Connect to the running spoonbot Erlang Node and hot load a new command remotely.

```
♪  spoonbot git:(master) ✗ iex --sname bark
Erlang/OTP 17 [erts-6.0] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (0.13.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(bark@argo)1> Node.connect :spoonbot@argo
true
iex(bark@argo)3> import Spoonbot
nil
    
iex(bark@argo)4> command "mirror me", &(String.reverse(&1))
:ok

```

The command will be ready in the bot.

Add more commands in spoonbot.exs or build your own exs file and parse it in the remote node:

```
iex(bark@argo)4> Code.require_file("alternate_commands.exs") 
```
