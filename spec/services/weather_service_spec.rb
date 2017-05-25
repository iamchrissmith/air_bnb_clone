require 'rails_helper'

describe WeatherService do
  it "returns raw weather details" do
    VCR.use_cassette('weather_service', record: :new_episodes) do
      property = create(:property, city: "Chickasha", state: "OK")
      service = WeatherService.new({city: property.city, state: property.state})
      weather = service.find_by_location

      expect(weather).to be_a(Hash)
      expect(weather).to have_key(:weather)
      expect(weather).to have_key(:temperature_string)
      expect(weather).to have_key(:wind_string)
      expect(weather[:weather]).to be_a(String)
      expect(weather[:temperature_string]).to be_a(String)
      expect(weather[:wind_string]).to be_a(String)
    end
  end
end
