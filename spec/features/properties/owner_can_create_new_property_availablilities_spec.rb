require 'rails_helper'

feature "an owner can create a property's availability" do
  context "as a logged in user" do

    attr_reader :user, :rando, :property, :rando_prop, :room_type
    before do
      @user = create(:user)
      @room_type = create(:room_type)
      @property = create(:property, room_type: @room_type)
      @rando_prop = create(:property)
      @user.properties << property
      login(user)
    end

    scenario "I can create new property availability" do
      VCR.use_cassette('property_weather_service', record: :new_episodes) do
        visit new_property_property_availability_path(@property)

        fill_in :first_available_date, with:"#{Date.today}"
        fill_in :last_available_date, with:"#{(Date.today + 5)}"
        click_on "Complete"

        expect(current_path).to eq(property_path(@property))
        expect(page).to have_content("Your available dates have been set.")

        visit property_property_availabilities_path(@property)

        expect(page).to have_content("#{(Date.today).strftime('%b %d, %Y')}")
      end
    end

    scenario "I can't create property availability for dates that I've already created" do
      @property.property_availabilities.create(date: Date.today)
      visit new_property_property_availability_path(@property)

      fill_in :first_available_date, with:"#{Date.today}"
      fill_in :last_available_date, with:"#{(Date.today + 5)}"
      click_on "Complete"

      expect(current_path).to eq(new_property_property_availability_path(@property))
      expect(page).to have_content("Sorry! Something went wrong. Please check your dates and try again.")
    end
  end
end
