require 'rails_helper'

RSpec.feature 'Owner can view properties index' do
  context 'when I visit my properties' do
    let(:owner) { create(:user) }
    let(:renter) { create(:user) }
    let(:property1) { create(:property, owner: owner) }
    let(:property2) { create(:property, owner: owner) }
    let!(:pending_request) { create(:reservation,
                                          property: property1,
                                          renter: renter,
                                          status: 0,
                                          start_date: Date.today + 10,
                                          end_date: Date.today + 13) }
    let!(:confirmed_request) { create(:reservation,
                                          property: property1,
                                          renter: renter,
                                          status: 1,
                                          start_date: Date.today + 4,
                                          end_date: Date.today + 5) }
    let!(:in_progress_request) { create(:reservation,
                                          property: property1,
                                          renter: renter,
                                          status: 2,
                                          start_date: Date.today - 1,
                                          end_date: Date.today + 3) }
    let!(:finished_request) { create(:reservation,
                                          property: property2,
                                          renter: renter,
                                          status: 3) }
    let!(:declined_request) { create(:reservation,
                                          property: property2,
                                          renter: renter,
                                          status: 4) }

    scenario 'owner can see properties with summary of requests' do
      login(owner)

      visit user_properties_path

      expect(page).to have_content "My Properties"
      within ("#property-#{property1.id}") do
        expect(page).to have_content property1.name
        expect(page).to have_content property1.status
        expect(page).to have_content "$#{property1.price_per_night}"
        expect(page).to have_content "Guests: #{property1.number_of_guests}"
        expect(page).to have_content "Beds: #{property1.number_of_beds}"
        expect(page).to have_content "Rooms: #{property1.number_of_rooms}"
        expect(page).to have_content "Bathrooms: #{property1.number_of_bathrooms}"
        expect(page).to have_content "Total Reservation Requests: 3"
        expect(page).to have_content "In Progress 1"
        expect(page).to have_content "Pending 1"
        expect(page).to have_content "Confirmed 1"
        expect(page).to have_content "Past 0"
        expect(page).to have_content "Declined 0"
      end

      within ("#property-#{property2.id}") do
        expect(page).to have_content property2.name
        expect(page).to have_content property2.status
        expect(page).to have_content "$#{property2.price_per_night}"
        expect(page).to have_content "Guests: #{property2.number_of_guests}"
        expect(page).to have_content "Beds: #{property2.number_of_beds}"
        expect(page).to have_content "Rooms: #{property2.number_of_rooms}"
        expect(page).to have_content "Bathrooms: #{property2.number_of_bathrooms}"
        expect(page).to have_content "Total Reservation Requests: 2"
        expect(page).not_to have_content "In Progress"
        expect(page).not_to have_content "Pending"
        expect(page).to have_content "Confirmed 0"
        expect(page).to have_content "Past 1"
        expect(page).to have_content "Declined 1"
      end
    end
  end
end
