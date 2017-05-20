require 'rails_helper'

feature "Facebook login" do
  stub_facebook
  let(:already_created_user) {create(:user)}

  context "User can create an account with their facebook login" do


    scenario "visit sign up page", vcr: true do
      visit root_path
      click_on "Sign Up"

      expect(current_path).to eq(sign_up_path)
    end

    scenario "begins building an account profile with facebook info", vcr: true do
      already_created_user.update(phone_number: nil)
      allow(User).to receive(:from_omniauth).and_return(already_created_user)
      
      visit sign_up_path

      click_on "Sign up with Facebook"
      expect(current_path).to eq(edit_user_path(already_created_user))
      expect(page).to have_content("Edit profile")
      expect(find_field("First name").value).to eq(already_created_user.first_name)
      expect(find_field("Last name").value).to eq(already_created_user.last_name)
      expect(find_field("Email").value).to eq(already_created_user.email)
      expect(find_field("Image url").value).to eq(already_created_user.image_url)

      fill_in "Phone number", with: '555-555-555'
      fill_in "Description", with: 'HEY!'
      fill_in "Hometown", with: 'STL'

      click_on "Update Profile"

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("hello #{already_created_user.first_name}")
      expect(page).to have_css("img[src*='#{already_created_user.image_url}']")
    end
  end

  context "User can log in with their facebook login" do
    let!(:already_created_user) {create(:user)}
    scenario "visits login page" do
      visit root_path
      click_on "Log In"

      expect(current_path).to eq(log_in_path)
    end

    scenario "user can login with facebook credentials" do
      allow(User).to receive(:from_omniauth).and_return(User.last)
      visit log_in_path
      click_on "Log in with Facebook"

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("hello #{already_created_user.first_name}")
    end
  end

    xscenario "user has same email for facebook and google" do

    end
end
