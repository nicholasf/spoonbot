defmodule Bridge.HTTP do
  import Plug.Connection

  def run(vocab) do
    IO.puts "Running HTTPPlug with Cowboy on http://localhost:4000"
    Plug.Adapters.Cowboy.http Bridge.HTTP , []
  end

  def call(conn, []) do
    conn = conn
           |> put_resp_content_type("text/plain")
           |> send_resp(200, "Hello world")
    { :ok, conn }
  end
end

