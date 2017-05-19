require 'rails_helper'

feature "Facebook login" do
  attr_reader :user, :already_created_user
  before do
    @user = stub_facebook
    @already_created_user = create(:user)
  end

  context "User can create an account with thier facebook login" do


    scenario "visit sign up page", vcr: true do
      visit root_path
      click_on "Sign up"

      expect(current_path).to eq(signup_path)
  end

    scenario "begins building an account profile with facebook info", vcr: true do
      visit signup_path
      click_on "Sign up with Facebook"

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.last)
      expect(current_path).to eq(edit_user_path(User.last))
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

  context "User can log in with thier facebook login" do
    scenario "vitsts login page" do
      visit root_path
      click_on "Log in"

      expect(current_path).to eq(login_path)
  end

    scenario "user can login with facebook credentials" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(already_created_user)
      visit login_path

      click_on "Log in with Facebook"

# byebug
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("hello #{already_created_user.first_name}")
    end
  end
end
