require 'rails_helper'

describe Weather do
  it "returns weather conditions for a location" do
    VCR.use_cassette('weather', record: :new_episodes) do
      property = create(:property, city: "New York", state: "NY")
      property1 = create(:property, city: "Chickasha", state: "OK")
      weather = property.get_weather
      weather1 = property1.get_weather

      expect(weather.class).to eq(Weather)
      expect(weather.conditions).to eq("Clear")
      expect(weather.temperature).to eq("61.5 F (16.4 C)")
      expect(weather.wind).to eq("From the WNW at 5.1 MPH Gusting to 7.4 MPH")
      expect(weather1.conditions).to eq("Clear")
      expect(weather1.temperature).to eq("77 F (25 C)")
      expect(weather1.wind).to eq("From the East at 6 MPH")
    end
  end
end
