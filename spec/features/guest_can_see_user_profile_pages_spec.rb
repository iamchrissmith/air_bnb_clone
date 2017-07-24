require 'rails_helper'

feature "a guest can view user profile pages" do
  attr_reader :properties
  before do
    @user = create(:user)
  end
  scenario "and can see user info" do

    visit user_path(@user)

    expect(page).to have_content("Hey, I'm #{@user.first_name}")
    expect(page).to have_content(@user.hometown)
    expect(page).to have_content(@user.description)
    expect(page).not_to have_link('Edit Profile')
  end

  xscenario 'guest can see user reviews' do
    # expect(page).to have_content(@user.reviews)
  end

  xscenario 'guest can message user' do
    # expect(page).to have_link('Message me')
  end
end
