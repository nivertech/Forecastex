defmodule ReportFormatter do
	
	def simple_format(reports) do
	  Enum.reduce(reports, "", _report_to_simple_string(&1, &2))
	end
	
	defp _report_to_simple_string(report, acc) do
	  acc <> "#{_format_time(report.time)} #{report.latitude}˚ #{report.longitude}˚ #{report.summary} Humidity: #{report.humidity} Sunrise: #{_format_time(report.sunrise)} Sunset: #{_format_time(report.sunset)} Wind speed: #{report.wind_speed} Wind direction: #{report.wind_direction}\n"
	end
	
	defp _format_time(datetime) do
		DateTime.datetime_to_us_short_datetime_format(datetime)
	end
	
end