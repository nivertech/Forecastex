defmodule Weather.Mixfile do
  use Mix.Project

  @api_key nil  # Specify your API key here.

  def project do
    [ app: :weather,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ 
      applications: [ :httpotion ],
      mod: { Weather, @api_key },
      registered: [ :forecast, :reporter ]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      {:httpotion,"0.1.0",[github: "myfreeweb/httpotion"]},
      {:jsonex, "2.0", [github: "marcelog/jsonex", tag: "2.0"]}
    ]
  end
end
