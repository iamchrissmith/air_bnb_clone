require 'rails_helper'

feature "User can authenticate account via text" do
  scenario "Registered user receives a text to set up 2 factor authentication" do

    visit root_path

    click_on "Sign up"

    expect(current_path).to eq(sign_up_path)

    click_on "Sign Up with Email"

    within(".2fa_auth") do
      expect(page).to have_content("Enable 2Auth")
    end

    click_on("Enable 2Auth")

    within(".2fa_auth") do
      expect(page).to have_content("Disable 2Auth")
    end
  end

  scenario "Signed out user does not see button" do

    click_on "Sign out"

    within(".2fa_auth") do
      expect(page).not_to have_content("Enable 2Auth")
    end
  end
end
