class Weather
  attr_reader :conditions, :temperature, :wind

  def initialize(raw_weather={})
    @conditions = raw_weather[:weather]
    @temperature = raw_weather[:temperature_string]
    @wind = raw_weather[:wind_string]
  end

end
