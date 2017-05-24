require 'rails_helper'

feature "as any kind of user, I can see where a property is located" do

  before do
    @property = create(:property)
    @key = ENV['GOOGLE_MAP_KEY']
  end

  scenario "when I visit a property's 'location' tab, I see a map" do
    visit property_path(@property)

    click_on'Location'

    expect(page).to have_css('iframe#map')
  end

  scenario "a property's map includes a pin at the location" do
    visit property_path(@property)

    click_on'Location'

    expect(page).to have_css("iframe[src='https://www.google.com/maps/embed/v1/place?key=#{@key}&q=#{@property.prepare_address}']")
  end
end
