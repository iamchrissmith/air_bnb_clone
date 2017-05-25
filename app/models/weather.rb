class Weather
  attr_reader :conditions, :temperature, :wind

  def initialize(attributes={})
    @conditions = attributes[:weather]
    @temperature = attributes[:temperature_string]
    @wind = attributes[:wind_string]
  end

end
