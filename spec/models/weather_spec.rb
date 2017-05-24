require 'rails_helper'

describe Weather do
  it "returns weather data for a location" do
    property = create(:property)
    weather = WeatherService.get_weather(property.city, property.state)

    expect(weather.weather).to eq("Clear")
    expect(weather.temperature_string).to eq("66.8 F (19.3 C)")
  end
end
