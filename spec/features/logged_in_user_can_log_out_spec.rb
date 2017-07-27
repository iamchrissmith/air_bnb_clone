require 'rails_helper'

feature "a logged in user can log out" do

  scenario "logged in with email and logs out" do
    user = create(:user)
    login(user)

    click_on('Log Out')

    expect(current_path).to eq(root_path)

    within(".alert") do
      expect(page).to have_content("Signed out successfully.")
    end
    expect(page).to have_link('Sign Up')
    expect(page).to have_content('Log In')
  end

  context "User is omniauth-authenticated" do

    before do
      create(:user)
      allow(User).to receive(:from_omniauth).and_return(User.last)
    end

    scenario "logged in with google and logs out" do
      stub_google

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

    scenario "logged in with facebook and logs out" do
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
end
