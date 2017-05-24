require 'rails_helper'

RSpec.feature "as a guest, when i visit a property's detail page" do
  scenario "i can see the current weather there" do
    property = create(:property)
    visit property_path(property)

    within first(".weather") do
      expect(page).to have_content("Current Weather: #{property.current_weather}")
    end

  end
end


# http://api.wunderground.com/api/a43d94e6bcd87693/conditions/q/CA/San_Francisco.json
