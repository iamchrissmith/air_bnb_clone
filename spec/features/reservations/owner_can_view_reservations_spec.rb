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

      expect(page).to have_content "Pending Requests"
      expect(page).to have_css('.nav-tabs a[href="#pending"]')
      expect(page).to have_css('.tab-content #pending')
      within ('.tab-content #pending') do
        expect(page).to have_css("#request-#{pending_request.id}")
        expect(page).not_to have_css("#request-#{confirmed_request.id}")
        expect(page).not_to have_css("#request-#{in_progress_request.id}")
        expect(page).not_to have_css("#request-#{finished_request.id}")
        expect(page).not_to have_css("#request-#{declined_request.id}")
      end
    end
  end
end
