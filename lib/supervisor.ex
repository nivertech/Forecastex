defmodule Weather.Supervisor do
	use Supervisor.Behaviour
	@vsn "0"
	
	def start_link(api_key) do
		:supervisor.start_link(__MODULE__, api_key)
	end
	
	def init(api_key) do
	  child_processes = [ 
	                     worker(Weather.Forecast, [api_key]), 
	                     worker(Weather.Reporter, [nil]) 
	                    ]
	  supervise child_processes, strategy: :one_for_one
	end
	
end
