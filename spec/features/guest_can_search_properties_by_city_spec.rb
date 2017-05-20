require 'rails_helper'

feature "a guest can search" do
  scenario "properties by location" do
    property = create(:property)
    property2 = create(:property, name: "cabin in the woods", city: "Denver")
    visit root_path

    fill_in :city, with:"#{property.city}"
    click_on "Search"

    expect(current_path).to eq(properties_path)

    expect(page).to have_content(property.city)

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end
end