defmodule Spoonbot do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Spoonbot.Supervisor.start_link
  end
end


defrecord RobotResponse, msg: nil

defprotocol Robot do
  def speak(robot_response)
end
