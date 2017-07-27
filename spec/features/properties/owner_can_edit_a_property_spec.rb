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
      VCR.use_cassette('property_weather_service', record: :new_episodes) do
        visit property_path(property)
        expect(page).to have_link('Edit this property')

        visit property_path(rando_prop)
        expect(page).to_not have_link('Edit this property')
      end
    end

    scenario "I can update one of my rental properties" do
      VCR.use_cassette('property_weather_service', record: :new_episodes) do
        visit property_path(property)
        click_on 'Edit this property'

        find(:css, "#room_type-#{room_type.id}").set(true)
        fill_in 'Number of beds', with: '8'
        fill_in 'Description', with: 'Have a Great time!'
        fill_in 'Check in time', with: '11:00 AM'
        fill_in 'Check out time', with: '4:00 PM'

        click_on 'Submit property for review'

        expect(current_path).to eq(property_path(property))
        expect(page).to have_content("Your edits have beeen submitted for approval. You will receive a notice when property is updated.")
      end
    end
  end
end
