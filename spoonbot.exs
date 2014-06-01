import Spoonbot

command "funky", fn (speaker) -> 
    "#{speaker}: cold medina!" 
end

command "heya", fn (speaker) -> 
    greetings = [
        "yo", "backatcha", "aight", "hi", "g'day",
    ]
    greeting = Enum.at greetings, round(:random.uniform ((Enum.count greetings) -1))
    "#{greeting} #{speaker}" 
end