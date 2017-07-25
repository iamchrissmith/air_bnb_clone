require 'rails_helper'

RSpec.feature 'a user can reserve a property' do
  let(:property) { create(:property) }
  
  context 'as a logged in user' do
    scenario 'User should be able to select dates and create reservation request'
  end
  context 'as a guest' do
    scenario 'Guest should see a login box not a reservation box' do
      VCR.use_cassette('reservation_property_weather_service') do
        visit property_path(property)
        within ('.booking-box') do
          expect(page).to have_content 'You must be logged in to reserve'
          expect(page).to have_link 'Sign Up', href: sign_up_path
          expect(page).to have_link 'Log In', href: log_in_path
          expect(page).not_to have_css('form')
        end
      end
    end
  end
end
