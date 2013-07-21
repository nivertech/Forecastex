# Weather

A simple Elixir wrapper around Forecast.io with a small demo.

---

## Running the sample app

1. In `mix.exs` set you API key from `developer.forecast.io`.

2. Start the sample app with `iex -S mix`. 

3. Query Forecast.io
  - Get the hourly forecast with `Weather.Reporter.get_hourly_forecast(latitude, longitude [, time])`
  - Get the daily forecast with `Weather.Reporter.get_daily_forecast(latitude, longitude [, time])`
