import Spoonbot

command "funky", &("#{&1}: cold medina!") 

command "say (.*)", fn (speaker, args) -> 
    "#{speaker}: #{Enum.at(args, 0)}" 
end

command "heya", fn (speaker) -> 
    greetings = [
        "yo", "backatcha", "aight", "hi", "g'day",
    ]
    greeting = Enum.at greetings, round(:rand.uniform ((Enum.count greetings) -1))
    "#{greeting} #{speaker}" 
end

command "die", &("No, you die #{&1}!")
command "quit", &("Haha, after you #{&1}!")
