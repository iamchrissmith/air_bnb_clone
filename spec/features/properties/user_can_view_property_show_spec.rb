require 'rails_helper'

feature "user can view to a property show page" do
  context "as a guest user" do
    scenario "returns property info" do
      property = create(:property)

      visit property_path(property)
      within(".property") do
        expect(page).to have_css("img[src*='#{property.image_url}']")
        within("h2") do
          expect(page).to have_content(property.name)
        end
        expect(page).to have_content(property.city)
        expect(page).to have_content(property.state)
        expect(page).to have_content(property.owner.full_name)
      end
      # It shows its photo, city/state, number of beds, number of guests,
      # number of rooms, room type, description, price per night, owner name,
      # owner photo, and a map with a general location of the property.
      # also a form where I can book reservation.
    end
  end
  context "as a logged in user" do

  end
  context "as an admin user" do
    # I can see links to remove
  end
end
