require 'rails_helper'

feature "Facebook login" do
  context "User can create an account with thier facebook login" do
    Capybara.app = FairBnb::Application
    user = stub_facebook

    scenario "visit sign up page", vcr: true do
      visit root_path
      click_on "Sign up"

      expect(current_path).to eq(signup_path)
  end

    scenario "begins building an account profile with facebook info", vcr: true do
      visit signup_path
      click_on "Sign up with Facebook"

      # new_user = User.create(first_name: 'Colleen', last_name: 'Ward', email: "ward.colleen.a@gmail.com", image_url: 'http://graph.facebook.com/v2.6/10100295829467675/picture')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.first)
      expect(current_path).to eq(edit_user_path(User.first))
      expect(page).to have_content("Edit profile")
      expect(find_field("First name").value).to eq("Colleen")
      expect(find_field("Last name").value).to eq("Ward")
      expect(find_field("Email").value).to eq("ward.colleen.a@gmail.com")
      expect(find_field("Image url").value).to eq("http://graph.facebook.com/v2.6/10100295829467675/picture")

      fill_in "Phone number", with: '555-555-555'
      fill_in "Description", with: 'HEY!'
      fill_in "Hometown", with: 'STL'

      click_on "Update Profile"

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("hello Colleen")
      expect(page).to have_css("img[src*='http://graph.facebook.com/v2.6/10100295829467675/picture']")
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
