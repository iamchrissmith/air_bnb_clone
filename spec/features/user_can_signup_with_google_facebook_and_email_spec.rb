require 'rails_helper'

feature "User can sign up with facebook, google, and email" do
  let(:already_created_user) {create(:user)}
  
  scenario "user can signup with same email for facebook and google" do
    visit sign_up_path
    click_on "Sign Up with Email"

    expect(current_path).to eq(new_user_registration_path)
    fill_in :user_first_name, with: "Erin"
    fill_in :user_last_name, with: "B"
    fill_in :user_email, with: "erin@erin.net"
    fill_in :user_phone_number, with: "123-456-7899"
    fill_in :user_image_url, with: "https://fakeimage.jpg"
    fill_in :user_password, with: "password"
    fill_in :user_password_confirmation, with: "password"
    click_on "Sign up"
    click_on "Log Out"
    
    stub_facebook
    already_created_user.update(phone_number: nil)
    allow(User).to receive(:from_omniauth).and_return(already_created_user)
    
    visit sign_up_path
    click_on "Sign up with Facebook"
    
    fill_in "Phone number", with: '555-555-555'
    fill_in "Description", with: 'HEY!'
    fill_in "Hometown", with: 'STL'
    
    click_on "Update Profile"
    click_on "Log Out"
    
    stub_google
    allow(User).to receive(:from_omniauth).and_return(User.last)
    
    click_on "Sign Up"
    click_on "Sign up with Google"
    
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("hello #{already_created_user.first_name}")
    expect(page).to have_css("img[src*='#{already_created_user.image_url}']")
  end
  
end