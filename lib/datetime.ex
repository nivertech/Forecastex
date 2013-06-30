defmodule DateTime do

  # Potential datetime libraries:
  # https://github.com/alco/elixir-datetime

  @type datetime :: { date, time }

  @type date :: { year, month, day }
  @type year :: non_neg_integer
  @type month :: 1..12
  @type day :: 1..31

  @type time :: { hour, minute, second }
  @type hour :: 0..23
  @type minute :: 0..59
  @type second :: 0..59
	
	@doc """
	Modified from http://stackoverflow.com/a/825439/371357
	"""
	def unix_timestamp_to_datetime(nil), do: nil
	def unix_timestamp_to_datetime(seconds) do
	  baseDate = :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})
	  finalSeconds = baseDate + seconds
	  :calendar.gregorian_seconds_to_datetime(finalSeconds)
	end
	
	def datetime_to_us_short_datetime_format(nil), do: nil
	def datetime_to_us_short_datetime_format({ { year, month, day }, { hour, minute, second} }) do
	  "#{month}/#{day}/#{year} #{hour}:#{minute}:#{second}"
	end
	
end