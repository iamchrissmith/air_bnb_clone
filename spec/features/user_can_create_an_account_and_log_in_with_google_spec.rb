require 'rails_helper'

RSpec.feature "User can authenticate with Google by" do

  scenario "creating an account with Google" do

    visit root_path

    click_on "Sign Up"

    expect(current_path).to eq(signup_path)

    click_on "Sign up with Google"

    expect(current_path).to eq(edit_profile_path)
    expect(page.body).to have_content("First name: Joe")
    expect(page.body).to have_content("Last name: Schmoe")
    expect(page.body).to have_content("Email address: JoeSchmoe123@gmail.com")
    expect(page.body).to have_link("Log out")
  end

  xscenario "logging in with Google" do

    visit login_path

    click_on "Log in with Google"

    expect(current_path).to eq(dashboard_path)
  end

end
