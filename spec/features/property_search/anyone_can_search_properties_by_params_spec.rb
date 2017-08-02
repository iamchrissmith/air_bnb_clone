require 'rails_helper'

unless ENV['TRAVIS']
  RSpec.describe "anyone can search properties" do

    before(:all) do
      @property1 = create(:property, description: 'Lakewood', address: '9227 W Mississippi Ave', city: 'Lakewood', state: 'CO')
      @property2 = create(:property, description: 'Aurora', address: '19599 E Bails Pl', city: 'Aurora', state: 'CO')
      @property3 = create(:property, description: 'Boulder', address: '880 33rd St', city: 'Boulder', state: 'CO')
      @property4 = create(:property, description: 'Vail', address: '245 Forest Rd', city: 'Vail', state: 'CO')
      @property5 = create(:property, description: 'Colorado Springs', address: '1 Olympic Plaza', city: 'Colorado Springs', state: 'CO')
    end

    let(:property1) { @property1.reload }
    let(:property2) { @property2.reload }
    let(:property3) { @property3.reload }
    let(:property4) { @property4.reload }
    let(:property5) { @property5.reload }

    it "and can search by location", :js => true do
      visit root_path

      find('#location').send_keys('denver')
      sleep(1)
      find('#location').send_keys(:down)
      sleep(1)
      find('#location').send_keys(:tab)

      expect(current_path).to eq('/properties')
      expect(page).to have_selector('.property-card', :count => 3)

      sleep(1)
      within(".property-frame") do
        expect(page).to have_content(property1.description)
        expect(page).to have_content(property2.description)
        expect(page).to have_content(property3.description)
        expect(page).to_not have_content(property4.description)
        expect(page).to_not have_content(property5.description)
      end
    end

    xit "can search by number of guests allowed" do
      property = create(:property, name: "cabin in the woods", number_of_guests: 5)
      property2 = create(:property)
      visit root_path

      fill_in :guests, with:"#{property.number_of_guests}"
      click_on "Search"

      expect(current_path).to eq(properties_path)
      expect(page).to have_content(property.number_of_guests)

      within(".results") do
        expect(page).to have_content(property.name)
        expect(page).to have_css("img[src*='#{property.image_url}']")
        expect(page).to_not have_content(property2.name)
      end
    end

    xit "can search by range of dates" do
      property = create(:property, name: "airstream")
      property2 = create(:property)

      property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property, date: Date.tomorrow, reserved?: false)
      property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
      property_availability = create(:property_availability, property: property2, date: Date.tomorrow, reserved?: false)
      visit root_path

      fill_in :check_in, with:"#{Date.today}"
      fill_in :check_out, with:"#{Date.tomorrow}"

      click_on "Search"
      expect(current_path).to eq(properties_path)
      within(".results") do
        expect(page).to have_content(property.name)
        expect(page).to have_css("img[src*='#{property.image_url}']")
        expect(page).to_not have_content(property2.name)
      end
    end

    xit "can search by city and number of guests allowed" do
      property = create(:property, name: "cabin in the woods", city: "Denver", number_of_guests: 5)
      property2 = create(:property)
      visit root_path

      fill_in :location, with:"#{property.city}"
      fill_in :guests, with:"#{property.number_of_guests}"
      click_on "Search"

      expect(current_path).to eq(properties_path)
      expect(page).to have_content(property.city)


      within(".results") do
        expect(page).to have_content(property.name)
        expect(page).to have_css("img[src*='#{property.image_url}']")
        expect(page).to_not have_content(property2.name)
      end
    end

    xit "can search by city and date range" do
      property = create(:property, name: "airstream", city: "Denver")
      property2 = create(:property)
      property3 = create(:property, name: "cabin in the woods")
      property4 = create(:property, name: "cabin", city: "Denver", number_of_guests: 5)

      property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property, date: Date.tomorrow, reserved?: false)
      property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
      property_availability = create(:property_availability, property: property3, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property4, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property4, date: Date.tomorrow, reserved?: false)
      visit root_path

      fill_in :location, with:"#{property.city}"
      fill_in :check_in, with:"#{Date.today}"
      fill_in :check_out, with:"#{Date.tomorrow}"
      click_on "Search"

      expect(current_path).to eq(properties_path)

      within(".results") do
        expect(page).to have_content(property.name)
        expect(page).to have_css("img[src*='#{property.image_url}']")
        expect(page).to have_content(property4.name)
        expect(page).to have_css("img[src*='#{property4.image_url}']")
        expect(page).to_not have_content(property2.name)
      end
    end

    xit "search by date range and number of guests" do
      property = create(:property, name: "airstream", city: "Denver", number_of_guests: 4)
      property2 = create(:property)
      property3 = create(:property, name: "cabin in the woods", number_of_guests: 10)
      property4 = create(:property, name: "cabin", city: "Denver", number_of_guests: 5)

      property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
      property_availability = create(:property_availability, property: property3, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property3, date: Date.tomorrow, reserved?: false)
      property_availability = create(:property_availability, property: property4, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property4, date: Date.tomorrow, reserved?: false)
      visit root_path

      fill_in :check_in, with:"#{Date.today}"
      fill_in :check_out, with:"#{Date.tomorrow}"
      fill_in :guests, with:"#{property4.number_of_guests}"

      click_on "Search"
      expect(current_path).to eq(properties_path)

      within(".results") do
        expect(page).to have_content(property4.city)
        expect(page).to have_content(property4.name)
        expect(page).to have_css("img[src*='#{property4.image_url}']")
        expect(page).to have_content(property3.city)
        expect(page).to have_content(property3.name)
        expect(page).to have_css("img[src*='#{property3.image_url}']")
        expect(page).to_not have_content(property.name)
      end
    end

    xit "can serch by city, date range and number of guests" do
      property = create(:property, name: "airstream", city: "St. Louis", number_of_guests: 4)
      property2 = create(:property)
      property3 = create(:property, name: "cabin in the woods", number_of_guests: 10)
      property4 = create(:property, name: "cabin", city: "Denver", number_of_guests: 5)

      property_availability = create(:property_availability, property: property, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property2, date: Date.today, reserved?: true)
      property_availability = create(:property_availability, property: property3, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property4, date: Date.today, reserved?: false)
      property_availability = create(:property_availability, property: property4, date: Date.tomorrow, reserved?: false)
      visit root_path

      fill_in :location, with:"#{property4.city}"
      fill_in :check_in, with:"#{Date.today}"
      fill_in :check_out, with:"#{Date.tomorrow}"
      fill_in :guests, with:"#{property4.number_of_guests}"

      click_on "Search"

      expect(current_path).to eq(properties_path)

      within(".results") do
        expect(page).to have_content(property4.name)
        expect(page).to have_css("img[src*='#{property4.image_url}']")
        expect(page).to_not have_content(property2.name)
        expect(page).to_not have_content(property.name)
      end
    end
  end
end