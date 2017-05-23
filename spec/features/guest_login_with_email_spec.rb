require 'rails_helper'

RSpec.feature "guest can login with email" do
  scenario "guest can register" do
    visit root_path
    click_on "Sign Up"

    expect(current_path).to eq(sign_up_path)

    click_on "Sign up with Email"

    expect(current_path).to eq(new_user_registration_path)
    fill_in :user_first_name, with: "Erin"
    fill_in :user_last_name, with: "B"
    fill_in :user_email, with: "erin@erin.net"
    fill_in :user_phone_number, with: "123-456-7899"
    fill_in :user_image_url, with: "https://fakeimage.jpg"
    fill_in :user_password, with: "password"
    fill_in :user_password_confirmation, with: "password"
    click_on "Sign Up"

    within(".alert") do
      expect(page).to have_content("Welcome! You have signed up successfully.")
    end
    expect(current_path).to eq(root_path)
  end

  scenario "guest can login as new registered user" do
    @user = create(:user)
    visit root_path
    click_on "Log In"

    expect(current_path).to eq(log_in_path)
    click_on "Log in with Email"

    expect(current_path).to eq(new_user_session_path)
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: @user.password
    click_on "Log in"

    expect(current_path).to eq(root_path)
    within(".alert") do
      expect(page).to have_content("Signed in successfully.")
    end

  end
end
