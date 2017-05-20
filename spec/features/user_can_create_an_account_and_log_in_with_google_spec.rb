require 'rails_helper'

RSpec.feature "User can authenticate with Google by" do

  before do
    stub_google_oauth
  end

  xscenario "creating an account with Google" do

    visit root_path

    click_on "Sign Up"


    expect(current_path).to eq(signup_path)

    click_on "Sign up with Google"

    # allow_any_instance_of(ApplicationController)
    #   .to receive(:current_user)
    #   .and_return(User.first)

    expect(current_path).to eq(edit_user_path(User.first))
    expect(page.body).to have_content("First name: Joe")
    expect(page.body).to have_content("Last name: Schmoe")
    expect(page.body).to have_content("Email address: JoeSchmoe123@gmail.com")
    expect(page.body).to have_link("Log Out")
  end

  scenario "logging in with Google" do

    visit log_in_path

    click_on "Log in with Google"

    expect(current_path).to eq(dashboard_path)
    expect(page.body).to have_content("First name: Beth")
    expect(page.body).to have_content("Last name: Knight")
    expect(page.body).to have_content("Email address: BethKnight1234@gmail.com")
  end

end
