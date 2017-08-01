require 'rails_helper'

RSpec.feature "as an admin " do
  scenario "i can see pending properties" do
    admin = create(:user, role: 1)
    property = create(:property, status: 0)
    login(admin)

    within (".session-nav") do
      click_on "Administer Properties"
    end

    expect(current_path).to eq(admin_properties_path)

    within(".pending_properties") do
      expect(page).to have_content(property.name)
      expect(page).to have_selector(:link_or_button, 'Activate')
    end

  end

  scenario "i can change the status of a pending property to active" do
    admin = create(:user, role: 1)
    property = create(:property, status: 0)
    login(admin)

    visit admin_properties_path

    within(".pending_properties") do
      expect(page).to have_content(property.name)
      click_on "Activate"
    end

    within(".pending_properties") do
      expect(page).to_not have_content(property.name)
    end

    within(".all_properties") do
      expect(page).to have_content(property.name)
    end
  end
end
