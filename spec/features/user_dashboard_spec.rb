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
      confirmed_res = create(:reservation, renter: user)
      login(user)

      visit dashboard_path

      expect(page).to have_content("Pending Reservations")
      expect(page).to have_css('.nav-tabs a[href="#pending"]')
      expect(page).to have_css('.tab-content #pending')
      within ('.tab-content #pending') do
        expect(page).to have_css("#reservation-#{reservation.id}")
        expect(page).to have_content reservation.start_date.to_formatted_s(:short)
        expect(page).to have_content reservation.end_date.to_formatted_s(:short)
        expect(page).to have_link(reservation.property.name, href: property_path(reservation.property))
        expect(page).to have_content "$#{reservation.total_price}"
        expect(page).to have_content "Requested: #{reservation.created_at.to_formatted_s(:short)}"
        expect(page).not_to have_css("#reservation-#{confirmed_res.id}")
      end
    end

    scenario "I see my confirmed reservations" do
      reservation = create(:reservation, renter: user, status: 0)
      confirmed_res = create(:reservation, renter: user)
      login(user)

      visit dashboard_path

      expect(page).to have_content("Confirmed Reservations")
      expect(page).to have_css('.nav-tabs a[href="#confirmed"]')
      expect(page).to have_css('.tab-content #confirmed')
      within ('.tab-content #confirmed') do
        expect(page).to have_css("#reservation-#{confirmed_res.id}")
        expect(page).to have_content confirmed_res.start_date.to_formatted_s(:short)
        expect(page).to have_content confirmed_res.end_date.to_formatted_s(:short)
        expect(page).to have_link(confirmed_res.property.name, href: property_path(confirmed_res.property))
        expect(page).to have_content "$#{confirmed_res.total_price}"
        expect(page).to have_content "Requested: #{confirmed_res.created_at.to_formatted_s(:short)}"
        expect(page).not_to have_css("#reservation-#{reservation.id}")
      end
    end

    scenario "I see my finished reservations" do
      reservation = create(:reservation, renter: user, status: 3)
      confirmed_res = create(:reservation, renter: user)
      login(user)

      visit dashboard_path

      expect(page).to have_content("Past Reservations")
      expect(page).to have_css('.nav-tabs a[href="#finished"]')
      expect(page).to have_css('.tab-content #finished')
      within ('.tab-content #finished') do
        expect(page).to have_css("#reservation-#{reservation.id}")
        expect(page).to have_content reservation.start_date.to_formatted_s(:short)
        expect(page).to have_content reservation.end_date.to_formatted_s(:short)
        expect(page).to have_link(reservation.property.name, href: property_path(reservation.property))
        expect(page).to have_content "$#{reservation.total_price}"
        expect(page).to have_content "Requested: #{reservation.created_at.to_formatted_s(:short)}"
        expect(page).not_to have_css("#reservation-#{confirmed_res.id}")
      end
    end

    scenario "I see my declined reservations" do
      reservation = create(:reservation, renter: user, status: 4)
      confirmed_res = create(:reservation, renter: user)
      login(user)

      visit dashboard_path

      expect(page).to have_content("Declined Reservations")
      expect(page).to have_css('.nav-tabs a[href="#declined"]')
      expect(page).to have_css('.tab-content #declined')
      within ('.tab-content #declined') do
        expect(page).to have_css("#reservation-#{reservation.id}")
        expect(page).to have_content reservation.start_date.to_formatted_s(:short)
        expect(page).to have_content reservation.end_date.to_formatted_s(:short)
        expect(page).to have_link(reservation.property.name, href: property_path(reservation.property))
        expect(page).to have_content "$#{reservation.total_price}"
        expect(page).to have_content "Requested: #{reservation.created_at.to_formatted_s(:short)}"
        expect(page).not_to have_css("#reservation-#{confirmed_res.id}")
      end
    end
  end
end