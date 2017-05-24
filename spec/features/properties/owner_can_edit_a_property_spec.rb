require 'rails_helper'

feature "an owner can edit a rental property" do
  context "as a logged in user" do

    attr_reader :user, :rando, :property, :rando_prop, :room_type
    before do
      @user = create(:user)
      @rando = create(:user)
      @room_type = create(:room_type)
      @property = create(:property, room_type: @room_type)
      @rando_prop = create(:property)
      @user.properties << property
      @rando.properties << rando_prop
      login(user)
    end

    scenario "I can only visit the edit form for my properties" do
      visit property_path(property)
      expect(page).to have_link('Edit this property')

      visit property_path(rando_prop)
      expect(page).to_not have_link('Edit this property')

    end

    scenario "I can update one of my rental properties" do
      visit user_path(user)
      click_on 'Add a property'

      find(:css, "#room_type-#{room_type.id}").set(true)
      fill_in 'Name', with: 'Sweet Spot'
      fill_in 'Number of guests', with: '10'
      fill_in 'Number of beds', with: '6'
      fill_in 'Number of rooms', with: '6'
      fill_in 'Number of bathrooms', with: '4'
      fill_in 'Description', with: 'Great'
      fill_in 'Check in time', with: '11:00 AM'
      fill_in 'Check out time', with: '4:00 PM'
      fill_in 'Price per night', with: 100.00
      fill_in 'Address', with: '500 W. Street St.'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'Colorodo'
      fill_in 'Zip', with: '80230'
      fill_in 'Image url', with: 'https://fakepictureofahouse'

      click_on 'Submit property for review'

      expect(current_path).to eq(new_property_property_availability_path(@user.properties.last))
      expect(user.properties.last.status).to eq('pending')
    end
  end
end
