defmodule Weather.Forecast do
	use GenServer.Behaviour
	@vsn "0"
	
	alias HTTPotion.Response
	
	@user_agent [ "User-agent": "Elixir" ]
	
	# Constants for retrieving data from the weather service.
	@latitude    "latitude"
	@longitude   "longitude"
	@currently   "currently"
	@hourly      "hourly"
	@daily       "daily"
	@data        "data"
	@time        "time"
	@summary     "summary"
	@temperature "temperature"
	@sunriseTime "sunriseTime"
	@sunsetTime  "sunsetTime"
	@humidity    "humidity"
	@windSpeed   "windSpeed"
	@windBearing "windBearing"
	
	################
	# External API #
	################
	
	def start_link(api_key) do
	  :gen_server.start_link({ :local, :forecast }, __MODULE__, api_key, [])
	end
	
	@doc """
	Returns the full forecast in raw form.
	"""
	def get_forecast(latitude, longitude, time // nil) do
	  :gen_server.call :forecast, { :get_forecast, latitude, longitude, time }
	end
	
	@doc """
	Returns just the hourly forecast as a list of Report records.
	"""
	def get_hourly_forecast(latitude, longitude, time // nil) do
	  :gen_server.call :forecast, { :get_hourly_forecast, latitude, longitude, time }
	end
	
	##################
	# Helper methods #
	##################
	
	def process(api_key, latitude, longitude, time // nil) do
	  Weather.Forecast.fetch(api_key, latitude, longitude, time)
	    |> decode_response
	end
	
	def process_hourly_forecast(api_key, latitude, longitude, time // nil) do
	  Weather.Forecast.fetch(api_key, latitude, longitude, time)
  	  |> decode_response
	    |> extract_hourly_data
	end
	
	def fetch(api_key, latitude, longitude, time // nil) do
    case HTTPotion.get(forecast_url(api_key, latitude, longitude, time), @user_agent) do
      Response[ body: body, status_code: status, headers: _headers ] when status in 200..299 -> 
        { :ok, body }
      Response[ body: body, status_code: _status, headers: _headers ] ->
        { :error, body }
    end 
  end
  
  def forecast_url(api_key, latitude, longitude, nil),  do: "https://api.forecast.io/forecast/#{api_key}/#{latitude},#{longitude}"
  def forecast_url(api_key, latitude, longitude, time), do: "https://api.forecast.io/forecast/#{api_key}/#{latitude},#{longitude},#{time}"
  
  def decode_response({:ok, body}), do: Jsonex.decode(body) 
  def decode_response({:error, msg}) do
    error = Jsonex.decode(msg)
    IO.puts "Error fetching from Forecast.io: #{error}"
    System.halt(2)
  end
  
	def extract_hourly_data(response) do
	  latitude = ListDict.get(response, @latitude)
	  longitude = ListDict.get(response, @longitude)
	  response
	    |> ListDict.get(@hourly)
	    |> ListDict.get(@data)
	    |> generate_reports(latitude, longitude)
	end
	
	def generate_reports(data, latitude, longitude) when is_list(data) do
	  Enum.map(data, create_report(&1, latitude, longitude))
	end
	
	def create_report(listDict, latitude, longitude) do
	  Report.new latitude:       latitude, 
	             longitude:      longitude, 
	             time:           ListDict.get(listDict, @time)        |> DateTime.unix_timestamp_to_datetime(),
	             summary:        ListDict.get(listDict, @summary), 
	             temperature:    ListDict.get(listDict, @temperature), 
	             sunrise:        ListDict.get(listDict, @sunriseTime) |> DateTime.unix_timestamp_to_datetime(),
	             sunset:         ListDict.get(listDict, @sunsetTime)  |> DateTime.unix_timestamp_to_datetime(),
	             humidity:       ListDict.get(listDict, @humidity), 
	             wind_speed:     ListDict.get(listDict, @windSpeed), 
	             wind_direction: ListDict.get(listDict, @windBearing)
	end
	
	############################
	# GenServer implementation #
	############################
	
	def init(api_key) do
    { :ok, api_key }
  end
  
  def handle_call( { :get_forecast, latitude, longitude, time }, _from, api_key ) do
    { :reply, process(api_key, latitude, longitude, time), api_key }
  end
  
  def handle_call( { :get_hourly_forecast, latitude, longitude, time }, _from, api_key ) do
    { :reply, process_hourly_forecast(api_key, latitude, longitude, time), api_key }
  end
  
  def format_status(_reason, [ _pdict, api_key ]) do
    [data: [{'State', "Using API key: '#{api_key}'"}]]
  end
  
  def terminate(reason, api_key) do
    IO.puts "Weather.Forecast using API key '#{api_key}' died #{reason}."
  end
	
end