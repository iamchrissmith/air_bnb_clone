require 'rails_helper'

feature "a guest can search" do
  scenario "properties by location" do
    property = create(:property)
    property2 = create(:property, name: "cabin in the woods", city: "Denver")
    visit root_path

    fill_in "city", with:"#{property.city}"
    click_on "Search"
    expect(current_path).to eq(properties_path)
    expect(page).to have_content("Search Results")

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end

  scenario "properties by range of dates" do
    property = create(:property, name: "airstream")
    property2 = create(:property)

    property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property, date: Date.tomorrow, reserved?: false)
    property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
    property_availability = create(:property_availability, property: property2, date: Date.tomorrow, reserved?: false)
    visit root_path

    fill_in :check_in, with:"#{Date.today}"
    fill_in :check_out, with:"#{Date.tomorrow}"

    click_on "Search"
    expect(current_path).to eq(properties_path)
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
    # expect(page).to have_content(property.number_of_guests)

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end

  scenario "properties by city and date range" do
    property = create(:property, name: "airstream", city: "Denver")
    property2 = create(:property)
    property3 = create(:property, name: "cabin in the woods")
    property4 = create(:property, name: "cabin", city: "Denver", number_of_guests: 5)

    property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property, date: Date.tomorrow, reserved?: false)
    property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
    property_availability = create(:property_availability, property: property3, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property4, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property4, date: Date.tomorrow, reserved?: false)
    visit root_path

    fill_in :city, with:"#{property.city}"
    fill_in :check_in, with:"#{Date.today}"
    fill_in :check_out, with:"#{Date.tomorrow}"
    click_on "Search"

    expect(current_path).to eq(properties_path)

    within(".results") do
      expect(page).to have_content(property.name)
      expect(page).to have_css("img[src*='#{property.image_url}']")
      expect(page).to have_content(property4.name)
      expect(page).to have_css("img[src*='#{property4.image_url}']")
      expect(page).to_not have_content(property2.name)
    end
  end

  scenario "properties by date range and number of guests" do
    property = create(:property, name: "airstream", city: "Denver", number_of_guests: 4)
    property2 = create(:property)
    property3 = create(:property, name: "cabin in the woods", number_of_guests: 10)
    property4 = create(:property, name: "cabin", city: "Denver", number_of_guests: 5)

    property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
    property_availability = create(:property_availability, property: property3, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property3, date: Date.tomorrow, reserved?: false)
    property_availability = create(:property_availability, property: property4, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property4, date: Date.tomorrow, reserved?: false)
    visit root_path

    fill_in :check_in, with:"#{Date.today}"
    fill_in :check_out, with:"#{Date.tomorrow}"
    fill_in :guests, with:"#{property4.number_of_guests}"

    click_on "Search"
    expect(current_path).to eq(properties_path)

    within(".results") do
      expect(page).to have_content(property4.city)
      expect(page).to have_content(property4.name)
      expect(page).to have_css("img[src*='#{property4.image_url}']")
      expect(page).to have_content(property3.city)
      expect(page).to have_content(property3.name)
      expect(page).to have_css("img[src*='#{property3.image_url}']")
      expect(page).to_not have_content(property.name)
    end
  end

  scenario "properties by city, date range and number of guests" do
    property = create(:property, name: "airstream", city: "St. Louis", number_of_guests: 4)
    property2 = create(:property)
    property3 = create(:property, name: "cabin in the woods", number_of_guests: 10)
    property4 = create(:property, name: "cabin", city: "Denver", number_of_guests: 5)

    property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
    property_availability = create(:property_availability, property: property3, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property4, date: Date.today, reserved?: false)
    property_availability = create(:property_availability, property: property4, date: Date.tomorrow, reserved?: false)
    visit root_path

    fill_in :city, with:"#{property4.city}"
    fill_in :check_in, with:"#{Date.today}"
    fill_in :check_out, with:"#{Date.tomorrow}"
    fill_in :guests, with:"#{property4.number_of_guests}"

    click_on "Search"

    expect(current_path).to eq(properties_path)

    within(".results") do
      expect(page).to have_content(property4.name)
      expect(page).to have_css("img[src*='#{property4.image_url}']")
      expect(page).to_not have_content(property2.name)
      expect(page).to_not have_content(property.name)
    end
  end
  
end