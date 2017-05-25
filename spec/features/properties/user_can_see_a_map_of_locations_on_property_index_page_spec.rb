require 'rails_helper'

feature "user can view map of locations on a property index page" do
  context "as a guest user" do
    before do
      @property_1 = create(:property, name: "Beth's Place", address: "816 Acoma St", city: "Denver", state: "CO", zip: "80203")
      @property_2 = create(:property, name: "Crossfit Broadway", address: "1025 Acoma St", city: "Denver", state: "CO", zip: "80203")
      @property_3 = create(:property, name: "Lowdown", address: "800 Lincoln St", city: "Denver", state: "CO", zip: "80203")
      @key = ENV['GOOGLE_MAP_KEY']
    end

    scenario "returns property map locations" do

      visit properties_path

      within(".index_map") do

      iframe = page.find('iframe')

      expect(iframe[:src]).to eq("https://www.google.com/maps/embed/v1/place?key=#{@key}&q=[\"#{@property_1.prepare_address}\", \"#{@property_2.prepare_address}\", \"#{@property_3.prepare_address}\"]")
      end
    end
  end
end
