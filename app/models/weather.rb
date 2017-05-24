class Weather
  attr_reader :city, :state

  def initialize(attributes={})
    @city = attributes[:city]
    @state = attributes[:state]
  end

  def self.get_weather(city, state)
    WeatherService.find_by_location
  end

  def weather

  end

  def temperature
    
  end

  def wind

  end

end
