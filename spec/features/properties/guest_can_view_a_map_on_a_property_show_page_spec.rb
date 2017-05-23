require 'rails_helper'

feature "as any kind of user, I can see where a property is located" do

  before do
    @property = create(:property)
  end

  scenario "when I visit a property's 'location' tab, I see a map" do
    visit property_path(@property)

    click_on'Location'

    expect(page).to have_css('iframe#map')
  end

  xscenario "a property's map includes a pin at the location" do
    visit property_path(@property)

    click_on'Location'

# save_and_open_page
      expect(page).to have_css('iframe#map[source*=google]')
  end
end

# As a any kind of guest/user
# when I visit a property's show page
# and click on the 'location' tab
# I see a map with a pin in the location of the property
