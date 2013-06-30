defmodule Weather do

  def start(_type, nil) do
    IO.puts :stderr, IEx.color(:error, "Please specify your API key in mix.exs.")
    System.halt 3
  end
  
  def start(_type, api_key) do
    Weather.Supervisor.start_link(api_key)
  end
  
end
