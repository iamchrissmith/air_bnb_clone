require 'rails_helper'

RSpec.feature 'Owner can update a pending property reservation request' do
  context 'when I visit my property with a pending request' do
    let(:owner) { create(:user) }
    let(:renter) { create(:user) }
    let(:property) { create(:property, owner: owner) }
    let!(:pending_request) { create(:reservation,
                                          property: property,
                                          renter: renter,
                                          status: 0,
                                          start_date: Date.today + 10,
                                          end_date: Date.today + 13) }
    scenario 'owner can click a button to update the request from pending to approved' do
      login(owner)

      visit user_property_path(property)

      expect(page).to have_css('#pending-requests')

      within ('#pending-requests') do
        click_on "Approve Request"
      end

      expect(current_path).to eq user_property_path(property)

      expect(page).not_to have_css('#pending-requests')

      expect(page).to have_css('#confirmed-requests')
      within ('#confirmed-requests') do
        expect(page).to have_css("#request-#{pending_request.id}")
        expect(page).to have_content "Message User"
      end
    end

    scenario 'owner can click a button to update the request from pending to declined' do
      login(owner)

      visit user_property_path(property)

      expect(page).to have_css('#pending-requests')

      within ('#pending-requests') do
        click_on "Decline Request"
      end

      expect(current_path).to eq user_property_path(property)

      expect(page).not_to have_css('#pending-requests')

      expect(page).to have_css('#declined-requests')
      within ('#declined-requests') do
        expect(page).to have_css("#request-#{pending_request.id}")
      end
    end
  end
end
