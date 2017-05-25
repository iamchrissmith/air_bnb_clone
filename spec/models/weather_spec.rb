require 'rails_helper'

describe Weather do
  it "returns weather conditions for a location" do
    property = create(:property, city: "New York", state: "NY")
    # service = WeatherService.new({city: property.city, state: property.state})
    # weather = service.find_by_location

    weather = property.get_weather
byebug
    # weather = Weather.get_weather(property.city, property.state)
#expect weather to be a weather object
    expect(weather.condition).to eq("Clear")
    expect(weather.temperature).to eq("66.8 F (19.3 C)")
    expect(weather.wind).to eq("From the NW at 13 MPH Gusting to 22 MPH")
  end

  it "returns current temperature for a location" do
    property = create(:property)
    service = WeatherService.new({city: property.city, state: property.state})
    weather = service.find_by_location

    weather = Weather.get_weather(property.city, property.state)

    expect(weather.weather).to eq("Clear")
    expect(weather.temperature).to eq("66.8 F (19.3 C)")
    expect(weather.wind).to eq("From the NW at 13 MPH Gusting to 22 MPH")
  end

  it "returns wind report for a location" do
    property = create(:property)
    service = WeatherService.new({city: property.city, state: property.state})
    weather = service.find_by_location

    weather = Weather.get_weather(property.city, property.state)

    expect(weather.weather).to eq("Clear")
    expect(weather.temperature).to eq("66.8 F (19.3 C)")
    expect(weather.wind).to eq("From the NW at 13 MPH Gusting to 22 MPH")
  end
end
