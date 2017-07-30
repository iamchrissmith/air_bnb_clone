require 'rails_helper'

feature "a guest can view homepage" do
  attr_reader :properties

  before do
    room_type = create(:room_type)
    @properties = create_list(:property, 4, room_type: room_type)
  end

  scenario "and sees search bar, featured homes and destinations" do

    visit root_path

    expect(page).to have_content("Book unique homes and experience a city like a local.")

    within(".search_bar") do
      expect(page).to have_field("place_search")
      expect(page).to have_field("date_range")
      expect(page).to have_field("guests")
    end

    within(".all_homes")do
      expect(page).to have_css("img[src*='#{properties.first.image_url}']")
      expect(page).to have_content(properties.first.name)
      expect(page).to have_css("img[src*='#{properties.second.image_url}']")
      expect(page).to have_content(properties.second.name)
      expect(page).to have_css("img[src*='#{properties[2].image_url}']")
      expect(page).to have_content(properties[2].name)
      expect(page).to have_css("img[src*='#{properties.last.image_url}']")
      expect(page).to have_content(properties.last.name)
    end
  end
end
