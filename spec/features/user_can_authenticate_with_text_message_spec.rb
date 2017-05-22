require 'rails_helper'

feature "Guest can authenticate account via text" do
  scenario "guest receives a text to set up 2 factor authentication" do

    visit root_path
    click_on "Sign up"

    expect(current_path).to eq(sign_up_path)

    click_on "Sign Up with Email"

    expect(current_path).to eq()


  end

end
