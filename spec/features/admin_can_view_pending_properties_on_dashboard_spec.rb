require 'rails_helper'

RSpec.feature "as an admin " do
  scenario "i can see pending properties" do
    admin = create(:user, role: 1)
    property = create(:property, status: 0)
    login(admin)

    visit admin_dashboard_index_path

    within(".nav navbar") do
      click_on "Properties"
    end

    expect(current_path).to eq(admin_properties_index_path)

    within(".pending_properties") do
      expect(page).to have_content(property.name)
      expect(page).to have_selector(:link_or_button, 'Activate')
    end

  end

  xscenario "i can change the status of a pending property to active" do
    admin = create(:user, role: 1)
    property = create(:property, status: 0)
    login(admin)

    visit admin_properties_index_path

    within(".pending_properties") do
      expect(page).to have_content(property.name)
      click_on "Activate"
    end

      expect(property.status).to eq("active")
  
  end
end
# As an admin, when i visit dashboard path, I see my dashboard information, including a list of pending properties, a link to all properties and a link to all users.
