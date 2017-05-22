require 'rails_helper'

feature "as a logged in user" do
  context "when I visit my dashboard" do
    scenario "I can edit and view my profile" do
      user = create(:user)
      login(user)

      visit dashboard_path

      click_on'Edit Profile'

      expect(current_path).to eq(edit_user_path(user))

      fill_in 'First name', with: 'New first name'
      fill_in 'Last name', with: 'New last name'
      fill_in 'Phone number', with: 'New number'
      fill_in 'Email', with: 'new@email.com'
      fill_in 'Description', with: 'Something different'
      fill_in 'Hometown', with: 'I moved!'

      click_on 'Submit Profile'

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content('New first name')

      click_on 'View Profile'

      expect(current_path).to eq(user_path(user))
      expect(page).to have_content('New first name')
      expect(page).to have_content('New last name')
      expect(page).to have_content('Something different')
      expect(page).to have_content('I moved!')
    end
  end
end
