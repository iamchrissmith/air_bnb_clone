require 'rails_helper'


RSpec.describe Weather do

  def forecast
    OpenStruct.new(
      body: File.open('spec/fixtures/weather/for_location.json'))
  end

  it "returns weather conditions for a location" do
      allow_any_instance_of(WeatherService).to receive(:response).and_return(forecast)

      property = create(:property, city: "New York", state: "NY")
      weather = property.get_weather
      binding.pry
      expect(weather.class).to eq(Weather)
      expect(weather.conditions).to eq("Clear")
      expect(weather.temperature).to eq("61.5 F (16.4 C)")
      expect(weather.wind).to eq("From the WNW at 5.1 MPH Gusting to 7.4 MPH")
  end
end
