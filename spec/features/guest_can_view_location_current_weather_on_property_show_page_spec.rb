require 'rails_helper'

RSpec.feature "as a guest, when i visit a property's detail page" do
  scenario "i can see the current weather in that location" do
    VCR.use_cassette('guest_can_view_weather', record: :new_episodes) do
      property = create(:property, city: "New York", state: "NY")
      weather = property.get_weather
      visit property_path(property)

      within first(".weather") do
        expect(page).to have_content("Current weather:")
        expect(page).to have_content("Conditions: Clear")
        expect(page).to have_content("Temp: 60.4 F (15.8 C)")
        expect(page).to have_content("Wind: Calm")
      end
    end
  end
  scenario "i can see an error message when a property's city is invalid" do
    VCR.use_cassette('no_weather_for_invalid_cities', record: :new_episodes) do
      property = create(:property, city: "Macgyverville", state: "WY")
      weather = property.get_weather
      visit property_path(property)

      within first(".weather") do
        expect(page).to have_content("Current weather:")
        expect(page).to have_content("Invalid city name; no weather information available.")
      end
    end
  end
end
