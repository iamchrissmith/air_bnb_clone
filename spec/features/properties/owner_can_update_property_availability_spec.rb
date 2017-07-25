require 'rails_helper'

feature "an owner can edit a property's availability" do
  context "as a logged in user" do

    attr_reader :user, :rando, :property, :rando_prop, :room_type
    before do
      @user = create(:user)
      @room_type = create(:room_type)
      @property = create(:property, room_type: @room_type)
      @rando_prop = create(:property)
      @user.properties << property
      @user.properties.first.property_availabilities.create(date: Date.today)
      login(user)
    end

    scenario "I can edit my property's availability" do
      VCR.use_cassette('property_weather_service', record: :new_episodes) do
        visit property_path(property)
        click_on "View property availability"

        expect(current_path).to eq(property_property_availabilities_path(@property))

        expect(page).to have_content("Available Dates")
        expect(page).to have_content("#{(Date.today).strftime('%b %d, %Y')}")
        click_on "Make unavailable"

        expect(page).to_not have_content("#{Date.today}")
      end
    end

  end
end
