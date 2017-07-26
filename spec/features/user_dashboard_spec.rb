require 'rails_helper'

feature "as a logged in user" do
  context "when I visit my dashboard" do
    scenario "I see my name, photo, and links to view and edit my profile" do

      user = create(:user)
      login(user)

      visit dashboard_path

      expect(page).to have_css("img[src*='#{user.image_url}']")
      expect(page).to have_content(user.first_name)
      expect(page).to have_link('View Profile')
      expect(page).to have_link('Edit Profile')
      end
    end
end
