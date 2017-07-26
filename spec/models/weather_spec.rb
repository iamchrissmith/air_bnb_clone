require 'rails_helper'


RSpec.describe Weather do

  def forecast
    OpenStruct.new(
      body: File.read('spec/fixtures/weather/for_location.json'))
  end

  it "returns weather conditions for a location" do
      allow_any_instance_of(WeatherService).to receive(:response).and_return(forecast)

      property = create(:property, city: "New York", state: "NY")
      weather = property.get_weather

      expect(weather.class).to eq(Weather)
      expect(weather.conditions).to eq("Partly Cloudy")
      expect(weather.temperature).to eq("73.9 F (23.3 C)")
      expect(weather.wind).to eq("Calm")
  end
end
