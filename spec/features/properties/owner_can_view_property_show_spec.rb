require 'rails_helper'

RSpec.feature 'Owner can view properties index' do
  context 'when I visit my properties' do
    let(:owner) { create(:user) }
    let(:renter) { create(:user) }
    let(:property) { create(:property, owner: owner) }
    let!(:pending_request) { create(:reservation,
                                          property: property,
                                          renter: renter,
                                          status: 0,
                                          start_date: Date.today + 10,
                                          end_date: Date.today + 13) }
    let!(:confirmed_request) { create(:reservation,
                                          property: property,
                                          renter: renter,
                                          status: 1,
                                          start_date: Date.today + 4,
                                          end_date: Date.today + 5) }
    let!(:in_progress_request) { create(:reservation,
                                          property: property,
                                          renter: renter,
                                          status: 2,
                                          start_date: Date.today - 1,
                                          end_date: Date.today + 3) }
    let!(:finished_request) { create(:reservation,
                                          property: property,
                                          renter: renter,
                                          status: 3) }
    let!(:declined_request) { create(:reservation,
                                          property: property,
                                          renter: renter,
                                          status: 4) }

    scenario 'owner can see a single property with details about requests' do
      login(owner)

      visit user_property_path(property)

      expect(page).to have_content property.name

      expect(page).to have_css('#in-progress-requests')
      within ('#in-progress-requests') do
        expect(page).to have_css("#request-#{pending_request.id}")
      end
      expect(page).to have_css('#pending-requests')
      within ('#pending-requests') do
        expect(page).to have_css("#request-#{confirmed_request.id}")
      end
      expect(page).to have_css('#confirmed-requests')
      within ('#confirmed-requests') do
        expect(page).to have_css("#request-#{in_progress_request.id}")
      end
      expect(page).to have_css('#finished-requests')
      within ('#finished-requests') do
        expect(page).to have_css("#request-#{finished_request.id}")
      end
      expect(page).to have_css('#declined-requests')
      within ('#declined-requests') do
        expect(page).to have_css("#request-#{declined_request.id}")
      end
    end
  end
end
