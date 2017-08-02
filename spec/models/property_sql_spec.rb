require 'rails_helper'

RSpec.describe Property do

  describe 'sql queries' do

    it ".available" do
      valid1 = create(:property, name: 'Lakewood')
      valid2 = create(:property, name: 'Aurora')
      invalid1 = create(:property, name: 'Boulder')
      invalid2 = create(:property, name: 'Vail')
      invalid3 = create(:property, name: 'Colorado Springs')

      [valid1, valid2, invalid1, invalid2, invalid3].each do |property|
        property.property_availabilities << PropertyAvailability.set_availability(DateTime.new(2017,1,1), DateTime.new(2017,1,14))
      end

      prop_as = valid1.property_availabilities
      prop_as[3].update(reserved?: true)
      prop_as[10].update(reserved?: true)

      prop_as = valid2.property_availabilities
      prop_as[0..2].each { |pa| pa.update(reserved?: true) }
      prop_as[12..13].each { |pa| pa.update(reserved?: true) }

      prop_as = invalid1.property_availabilities
      prop_as[4].update(reserved?: true)

      prop_as = invalid2.property_availabilities
      prop_as[9].update(reserved?: true)

      prop_as = invalid3.property_availabilities
      prop_as[7].update(reserved?: true)

      results = Property.available({dates: '01/05/2017-01/10/2017'})

      expect(results.count).to eq(2)

      expect(results.include?(valid1)).to be_truthy
      expect(results.include?(valid2)).to be_truthy
      expect(results.include?(invalid1)).to be_falsey
      expect(results.include?(invalid2)).to be_falsey
      expect(results.include?(invalid3)).to be_falsey
    end

    it '.within_zone' do
      property1 = create(:property, name: 'Lakewood', address: '9227 W Mississippi Ave', city: 'Lakewood', state: 'CO')
      property2 = create(:property, name: 'Aurora', address: '19599 E Bails Pl', city: 'Aurora', state: 'CO')
      property3 = create(:property, name: 'Boulder', address: '880 33rd St', city: 'Boulder', state: 'CO')
      property4 = create(:property, name: 'Vail', address: '245 Forest Rd', city: 'Vail', state: 'CO')
      property5 = create(:property, name: 'Colorado Springs', address: '1 Olympic Plaza', city: 'Colorado Springs', state: 'CO')

      results = Property.within_zone( {lat: 39.7392, long: -104.9903, radius: 25} )

      expect(results.to_a.count).to eq(3)
      expect(results[0]).to eq(property1)
      expect(results[1]).to eq(property2)
      expect(results[2]).to eq(property3)

      expect(results.to_a.include?(property4)).to be_falsey
      expect(results.to_a.include?(property5)).to be_falsey
    end

    it '.with_guests' do
      property1 = create(:property, name: 'Lakewood', number_of_guests: 10)
      property2 = create(:property, name: 'Aurora', number_of_guests: 6)
      property3 = create(:property, name: 'Boulder', number_of_guests: 1)
      property4 = create(:property, name: 'Vail', number_of_guests: 2)
      property5 = create(:property, name: 'Colorado Springs', number_of_guests: 5)

      results = Property.with_guests( {guests: 5} )

      expect(results.to_a.count).to eq(3)
      expect(results.to_a.include?(property1)).to be_truthy
      expect(results.to_a.include?(property2)).to be_truthy
      expect(results.to_a.include?(property5)).to be_truthy

      expect(results.to_a.include?(property3)).to be_falsey
      expect(results.to_a.include?(property4)).to be_falsey
    end
  end
end