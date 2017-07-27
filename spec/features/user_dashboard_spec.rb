require 'rails_helper'

feature "as a logged in user" do
  context "when I visit my dashboard" do
    let(:user) { create(:user) }
    scenario "I see my name, photo, and links to view and edit my profile" do
      login(user)

      visit dashboard_path

      expect(page).to have_css("img[src*='#{user.image_url}']")
      expect(page).to have_content(user.first_name)
      expect(page).to have_link('View Profile')
      expect(page).to have_link('Edit Profile')
    end
    scenario "I see my pending reservations" do
      reservation = create(:reservation, renter: user, status: 0)
      login(user)

      visit dashboard_path

      expect(page).to have_content("Your Pending Reservations")
      expect(page).to have_css('.reservations .nav-tabs a[data-toggle="pending"]')
      expect(page).to have_css('.reservations .tab-content #pending')
      within ('.reservations .tab-content #pending') do
        expect(page).to have_content reservation.start_date
        expect(page).to have_content reservation.end_date
        expect(page).to have_link(reservation.property.name, href: property_path(reservation.property))
        expect(page).to have_content "Requested on: #{reservation.created_at}"
      end
    end
  end
  #Need to figure out messages...
  context "Within my notifications" do

    xscenario "I see the number of new messages with a link to messages" do

    end

    xscenario "I see the number of pending request with a link to pending reservations" do
    end
  end
end
