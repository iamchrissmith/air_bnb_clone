require 'rails_helper'

unless ENV['TRAVIS']
  RSpec.describe "anyone can search properties" do

    before(:all) do
      @property1 = create(:property, description: 'Lakewood', address: '9227 W Mississippi Ave', city: 'Lakewood', state: 'CO', number_of_guests: 8)
      @property2 = create(:property, description: 'Aurora', address: '19599 E Bails Pl', city: 'Aurora', state: 'CO', number_of_guests: 10)
      @property3 = create(:property, description: 'Boulder', address: '880 33rd St', city: 'Boulder', state: 'CO', number_of_guests: 6)
      @property4 = create(:property, description: 'Vail', address: '245 Forest Rd', city: 'Vail', state: 'CO', number_of_guests: 1)
      @property5 = create(:property, description: 'Colorado Springs', address: '1 Olympic Plaza', city: 'Colorado Springs', state: 'CO', number_of_guests: 2)

      [@property1, @property2, @property3, @property4, @property5].each do |property|
        property.property_availabilities << PropertyAvailability.set_availability(DateTime.new(2017,1,1), DateTime.new(2017,1,14))
      end

      prop_as = @property1.property_availabilities
      prop_as[3..10].each { |pa| pa.update(reserved?: true) }

      prop_as = @property2.property_availabilities
      prop_as[0..2].each { |pa| pa.update(reserved?: true) }
      prop_as[12..13].each { |pa| pa.update(reserved?: true) }

      prop_as = @property3.property_availabilities
      prop_as[4].update(reserved?: true)

      prop_as = @property4.property_availabilities
      prop_as[9].update(reserved?: true)

      prop_as = @property5.property_availabilities
      prop_as[7].update(reserved?: true)
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

      find('#guests').click
      sleep(0.5)
      find('#guests').send_keys(:left)
      find('#guests').send_keys(:delete)
      find('#guests').send_keys(7)
      sleep(1)
      find('#guests').send_keys(:tab)
      sleep(1)

      within(".property-frame") do
        expect(page).to have_content(property1.description)
        expect(page).to have_content(property2.description)
        expect(page).to_not have_content(property3.description)
        expect(page).to_not have_content(property4.description)
        expect(page).to_not have_content(property5.description)
      end

      find('#date_range').click
      sleep(1)
      fill_in('daterangepicker_start', with: "")
      find('input[name=daterangepicker_start]').send_keys('01/01/2017')
      sleep(1)
      fill_in('daterangepicker_end', with: "")
      find('input[name=daterangepicker_end]').send_keys('01/13/2017')
      sleep(1)
      find('#date_range').click
      find('#date_range').send_keys(:enter)
      sleep(5)

      within(".property-frame") do
        expect(page).to have_content(property1.description)
        expect(page).to have_content(property2.description)
        expect(page).to_not have_content(property3.description)
        expect(page).to_not have_content(property4.description)
        expect(page).to_not have_content(property5.description)
      end
    end
  end
end