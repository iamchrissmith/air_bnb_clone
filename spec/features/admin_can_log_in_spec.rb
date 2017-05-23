require 'rails_helper'

RSpec.feature "as an admin" do
  scenario "i can log in" do
    admin = create(:user, role: 1)

    visit log_in_path

    click_on "Log in with Email"

    expect(current_path).to eq(new_user_session_path)

    fill_in :user_email, with: "#{admin.email}"
    fill_in :user_password, with: "#{admin.password}"
    click_on "Log in"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Admin Dashboard")
  end
end
