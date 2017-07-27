require 'rails_helper'

RSpec.feature 'Owner can view requested requests' do
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

    scenario 'owner can see pending requests' do
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

    scenario 'owner can see confirmed requests' do
      login(owner)

      visit user_properties_path

      expect(page).to have_content "Confirmed Requests"
      expect(page).to have_css('.nav-tabs a[href="#confirmed"]')
      expect(page).to have_css('.tab-content #confirmed')
      within ('.tab-content #confirmed') do
        expect(page).not_to have_css("#request-#{pending_request.id}")
        expect(page).to have_css("#request-#{confirmed_request.id}")
        expect(page).not_to have_css("#request-#{in_progress_request.id}")
        expect(page).not_to have_css("#request-#{finished_request.id}")
        expect(page).not_to have_css("#request-#{declined_request.id}")
      end
    end

    scenario 'owner can see in_progress requests' do
      login(owner)

      visit user_properties_path

      expect(page).to have_content "In Progress Requests"
      expect(page).to have_css('.nav-tabs a[href="#in_progress"]')
      expect(page).to have_css('.tab-content #in_progress')
      within ('.tab-content #in_progress') do
        expect(page).not_to have_css("#request-#{pending_request.id}")
        expect(page).not_to have_css("#request-#{confirmed_request.id}")
        expect(page).to have_css("#request-#{in_progress_request.id}")
        expect(page).not_to have_css("#request-#{finished_request.id}")
        expect(page).not_to have_css("#request-#{declined_request.id}")
      end
    end

    scenario 'owner can see finished requests' do
      login(owner)

      visit user_properties_path

      expect(page).to have_content "Finished Requests"
      expect(page).to have_css('.nav-tabs a[href="#finished"]')
      expect(page).to have_css('.tab-content #finished')
      within ('.tab-content #finished') do
        expect(page).not_to have_css("#request-#{pending_request.id}")
        expect(page).not_to have_css("#request-#{confirmed_request.id}")
        expect(page).not_to have_css("#request-#{in_progress_request.id}")
        expect(page).to have_css("#request-#{finished_request.id}")
        expect(page).not_to have_css("#request-#{declined_request.id}")
      end
    end

    scenario 'owner can see declined requests' do
      login(owner)

      visit user_properties_path

      expect(page).to have_content "Declined Requests"
      expect(page).to have_css('.nav-tabs a[href="#declined"]')
      expect(page).to have_css('.tab-content #declined')
      within ('.tab-content #declined') do
        expect(page).not_to have_css("#request-#{pending_request.id}")
        expect(page).not_to have_css("#request-#{confirmed_request.id}")
        expect(page).not_to have_css("#request-#{in_progress_request.id}")
        expect(page).not_to have_css("#request-#{finished_request.id}")
        expect(page).to have_css("#request-#{declined_request.id}")
      end
    end
  end
end
