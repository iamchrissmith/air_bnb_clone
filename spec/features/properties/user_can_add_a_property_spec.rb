require 'rails_helper'

feature "user can add a rental property to thier account" do
  context "as a logged in user" do

    attr_reader :user, :rando, :property, :rando_prop, :room_type
    before do
      @user = create(:user)
      @room_type = create(:room_type)
      login(user)
    end

    scenario "I can visit the new property form" do
      visit user_path(user)
      expect(page).to have_link('Add a property')

      click_on 'Add a property'
      expect(current_path).to eq(new_property_path)
    end

    scenario "I can add a rental property to my account" do
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

      expect(current_path).to eq(new_property_property_availability_path(user.properties.last))

      fill_in :first_available_date, with:"#{Date.today}"
      fill_in :last_available_date, with:"#{(Date.today + 5)}"
      click_on "Complete"

      expect(current_path).to eq(property_path(user.properties.last))

      expect(user.properties.last.status).to eq('pending')
      expect(page).to have_content('Shared Room')
      expect(page).to have_content('10 Guests')
      expect(page).to have_content('6 Room')
      expect(page).to have_content('6 Beds')
      expect(page).to have_content('Sweet Spot')
      expect(page).to have_content('Accomodates: 10')
      expect(page).to have_content('Bathrooms: 4')
      expect(page).to have_content('Beds: 6')
      expect(page).to have_content('$100.00 per night')
    end

    scenario "new rental property is not created without all fields" do
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
      fill_in 'Address', with: '500 W. Street St.'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'Colorodo'
      fill_in 'Zip', with: '80230'
      fill_in 'Image url', with: 'https://fakepictureofahouse'

      click_on 'Submit property for review'

      expect(current_path).to eq(properties_path)
      expect(page).to have_content("Sorry! Something went wrong. Please try again.")
    end
  end
end
