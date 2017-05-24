require 'rails_helper'

feature "user can view map of locations on a property index page" do
  context "as a guest user" do
    scenario "returns property map locations" do

      property_1 = create(:property)
      property_2 = create(:property)
      property_3 = create(:property)

      visit properties_path

      within(".map-index") do
        source = page.find('div.map-index iFrame')[:src]
        expect(source).to matcher(property_1.address)
        expect(source).to matcher(property_2.address)
        expect(source).to matcher(property_3.address)
      end
    end
  end
end
