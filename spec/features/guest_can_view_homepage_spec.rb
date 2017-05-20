require 'rails_helper'

feature "a guest can view homepage" do
  before do
    room_type = create(:room_type)
    property1, property2, property3, property4 = create_list(:property, 4, room_type: room_type)
  end
  scenario "and sees search bar, featured homes and destinations" do

    visit root_path

    expect(page).to have_content("Book unique homes and experience a city like a local.")

    within(".search_bar") do
      expect(page).to have_field("Where")
      expect(page).to have_field("When")
      expect(page).to have_field("Guests")
      expect(page).to have_selector(:link_or_button, 'Search')
    end

    within(".all_homes")do
      expect(page).to have_content(property1.image_url)
      expect(page).to have_content(property1.name)
      expect(page).to have_content(property2.image_url)
      expect(page).to have_content(property2.name)
      expect(page).to have_content(property3.image_url)
      expect(page).to have_content(property3.name)
      expect(page).to have_content(property4.image_url)
      expect(page).to have_content(property4.name)
    end

    within(".featured_cities") do
      expect(page).to have_content(property1.city)
      expect(page).to have_content(property1.image_url)
      expect(page).to have_content(property2.city)
      expect(page).to have_content(property2.image_url)
      expect(page).to have_content(property3.city)
      expect(page).to have_content(property3.image_url)
      expect(page).to have_content(property4.city)
      expect(page).to have_content(property4.image_url)
    end
  end
end