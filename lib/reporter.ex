defmodule Weather.Reporter do
	use GenServer.Behaviour
	@vsn "0"
	
	################
	# External API #
	################
	
	def start_link(data) do
	  :gen_server.start_link({ :local, :reporter }, __MODULE__, data, [])
	end
	
	def get_hourly_forecast(latitude, longitude, time // nil) do
	  :gen_server.call :reporter, { :get_hourly_forecast, latitude, longitude, time }
	end
	
	##################
	# Helper methods #
	##################
	
	def process_hourly_forecast(latitude, longitude, time // nil) do
	  Weather.Forecast.get_hourly_forecast(latitude, longitude, time)
  	  |> ReportFormatter.simple_format()
  	  |> IO.puts()
	end
	
	############################
	# GenServer implementation #
	############################
	
	def init(pid) do
	  { :ok, pid }
	end
	
  def handle_call( { :get_hourly_forecast, latitude, longitude, time }, _from, data ) do
    { :reply, process_hourly_forecast(latitude, longitude, time), data }
  end
  
end