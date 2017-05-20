require 'rails_helper'

feature "a logged in user can log out" do
  scenario "logged in with email and logs out" do
    user = create(:user)

    visit log_in_path
    click_on('Log in with Email')

    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_on "Log in"


    click_on('Log Out')

    expect(current_path).to eq(root_path)

    within(".alert") do
      expect(page).to have_content("Signed out successfully.")
    end
    expect(page).to have_link('Sign Up')
    expect(page).to have_content('Log In')
  end

  xscenario "logged in with google and logs out" do
    stub_google_oauth
    visit log_in_path
    click_on('Log in with Google')


    click_on('Log Out')

    expect(current_path).to eq(root_path)

    within(".alert") do
      expect(page).to have_content("Signed out successfully.")
    end
    expect(page).to have_link('Sign Up')
    expect(page).to have_content('Log In')
  end

  xscenario "logged in with facebook and logs out" do
    stub_facebook
    visit log_in_path
    click_on('Log in with Facebook')


    click_on('Log Out')

    expect(current_path).to eq(root_path)

    within(".alert") do
      expect(page).to have_content("Signed out successfully.")
    end
    expect(page).to have_link('Sign Up')
    expect(page).to have_content('Log In')
  end
end
