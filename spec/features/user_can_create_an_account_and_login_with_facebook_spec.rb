require 'rails_helper'

feature "Facebook login" do
  context "User can create an account with thier facebook login" do
    # Capybara.app FairBnb::Application

    # stub_facebook

    scenario "visit sign up page", vcr: true do
      visit root_path
      click_on "Sign up"

      expect(current_path).to eq(signup_path)
  end

    scenario "begins building an account profile with facebook info", vcr: true do
      click_on "Sign up with Facebook"

      # expect(current_path).to eq(edit_profile_path)
      expect(page).to have_content("Edit profile")
      expect(page).to have_content("Stephanie")
      expect(page).to have_content("Bentley")
      expect(page).to have_content("stephanielague@gmail.com")
      # expect(page).to have_css("img[src*='http://graph.facebook.com/1234567/picture?type=square']")

      # fill_in "Phone Number", with:
      # fill_in "Description", with:
      # fill_in "Hometown", with:
    end
  end
end


#   context "User can log in with thier facebook login" do
#     it "logs in using facebook oauth" do
#       visit root_path
#       click_on "Log in"
#
#       expect(current_path).to eq(dashboard_path(user))
#   end
# end

# provider: 'facebook',
#   uid: '1234567',
#   info: {
#     email: 'joe@bloggs.com',
#     name: 'Joe Bloggs',
#     first_name: 'Joe',
#     last_name: 'Bloggs',
#     image: 'http://graph.facebook.com/1234567/picture?type=square',
#     verified: true
#   },
#   credentials: {
#     token: 'ABCDEF...', # O
