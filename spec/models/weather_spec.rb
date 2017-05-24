require 'rails_helper'

describe Weather do
  it "returns weather data for a location" do
    property = create(:property)
    weather = Weather.get_weather(property.city, property.state)

    expect(weather.weather).to eq("Clear")
    expect(weather.temperature).to eq("66.8 F (19.3 C)")
    expect(weather.wind).to eq("From the NW at 13 MPH Gusting to 22 MPH")
  end
end
