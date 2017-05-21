require 'rails_helper'

feature "a guest can search" do
  scenario "properties by location" do
    property = create(:property)
    property2 = create(:property, name: "cabin in the woods", city: "Denver")
    visit root_path

    fill_in :city, with:"#{property.city}"
    click_on "Search"

    expect(current_path).to eq(properties_path)

    expect(page).to have_content("Search Results")

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end
  
  xscenario "properties by date" do
    property = create(:property)
    property2 = create(:property, name: "cabin in the woods")
    property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
    visit root_path

    fill_in :check_in, with:"#{Date.today}"
    click_on "Search"

    expect(current_path).to eq(properties_path)
    expect(page).to have_content("Date: #{Date.today}")

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end
  
  scenario "properties by number of guests allowed" do
    property = create(:property, name: "cabin in the woods", number_of_guests: 5)
    property2 = create(:property)
    visit root_path

    fill_in :guests, with:"#{property.number_of_guests}"
    click_on "Search"

    expect(current_path).to eq(properties_path)
    expect(page).to have_content(property.number_of_guests)

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end
  
  scenario "properties by city and number of guests allowed" do
    property = create(:property, name: "cabin in the woods", city: "Denver", number_of_guests: 5)
    property2 = create(:property)
    visit root_path

    fill_in :city, with:"#{property.city}"
    fill_in :guests, with:"#{property.number_of_guests}"
    click_on "Search"

    expect(current_path).to eq(properties_path)
    expect(page).to have_content(property.city)
    expect(page).to have_content(property.number_of_guests)

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end
end