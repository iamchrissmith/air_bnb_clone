require 'rails_helper'

RSpec.describe Property do

  describe 'sql queries' do

    it ".available" do
      property1 = create(:property, name: 'Lakewood')
      property2 = create(:property, name: 'Aurora')
      property3 = create(:property, name: 'Boulder')
      property4 = create(:property, name: 'Vail')
      property5 = create(:property, name: 'Colorado Springs')

      [property1, property2, property3, property4, property5].each do |property|
        property.property_availabilities << PropertyAvailability.set_availability(DateTime.new(2017,1,1), DateTime.new(2017,1,14))
      end

      prop_as = property1.property_availabilities
      prop_as[3].update(reserved?: true)
      prop_as[10].update(reserved?: true)

      prop_as = property2.property_availabilities
      prop_as[0..2].each { |pa| pa.update(reserved?: true) }
      prop_as[12..13].each { |pa| pa.update(reserved?: true) }

      prop_as = property3.property_availabilities
      prop_as[4].update(reserved?: true)

      prop_as = property4.property_availabilities
      prop_as[9].update(reserved?: true)

      prop_as = property5.property_availabilities
      prop_as[7].update(reserved?: true)

      params = { dates: '01/05/2017-01/10/2017' }
      results = Property.available(params)

      expect(results.count).to eq(2)

      expect(results.include?(property1)).to be_truthy
      expect(results.include?(property2)).to be_truthy

      expect(results.include?(property3)).to be_falsey
      expect(results.include?(property4)).to be_falsey
      expect(results.include?(property5)).to be_falsey
    end

    it '.within_zone' do
      property1 = create(:property, name: 'Lakewood', address: '9227 W Mississippi Ave', city: 'Lakewood', state: 'CO')
      property2 = create(:property, name: 'Aurora', address: '19599 E Bails Pl', city: 'Aurora', state: 'CO')
      property3 = create(:property, name: 'Boulder', address: '880 33rd St', city: 'Boulder', state: 'CO')
      property4 = create(:property, name: 'Vail', address: '245 Forest Rd', city: 'Vail', state: 'CO')
      property5 = create(:property, name: 'Colorado Springs', address: '1 Olympic Plaza', city: 'Colorado Springs', state: 'CO')

      params = { location: { lat: 39.7392, long: -104.9903, radius: 25 } }
      results = Property.within_zone(params)

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

      params = { guests: 5 }
      results = Property.with_guests(params)

      expect(results.to_a.count).to eq(3)
      expect(results.to_a.include?(property1)).to be_truthy
      expect(results.to_a.include?(property2)).to be_truthy
      expect(results.to_a.include?(property5)).to be_truthy

      expect(results.to_a.include?(property3)).to be_falsey
      expect(results.to_a.include?(property4)).to be_falsey
    end

    describe '.search' do

      before(:each) do
        @property1 = create(:property, name: 'Lakewood', address: '9227 W Mississippi Ave', city: 'Lakewood', state: 'CO', number_of_guests: 10)
        @property2 = create(:property, name: 'Aurora', address: '19599 E Bails Pl', city: 'Aurora', state: 'CO', number_of_guests: 6)
        @property3 = create(:property, name: 'Boulder', address: '880 33rd St', city: 'Boulder', state: 'CO', number_of_guests: 1)
        @property4 = create(:property, name: 'Vail', address: '245 Forest Rd', city: 'Vail', state: 'CO', number_of_guests: 2)
        @property5 = create(:property, name: 'Colorado Springs', address: '1 Olympic Plaza', city: 'Colorado Springs', state: 'CO', number_of_guests: 5)

        [property1, property2, property3, property4, property5].each do |property|
          property.property_availabilities << PropertyAvailability.set_availability(DateTime.new(2017,1,1), DateTime.new(2017,1,14))
        end

        prop_as = property1.property_availabilities
        prop_as[3].update(reserved?: true)
        prop_as[10].update(reserved?: true)

        prop_as = property2.property_availabilities
        prop_as[0..2].each { |pa| pa.update(reserved?: true) }
        prop_as[12..13].each { |pa| pa.update(reserved?: true) }

        prop_as = property3.property_availabilities
        prop_as[4].update(reserved?: true)

        prop_as = property4.property_availabilities
        prop_as[9].update(reserved?: true)

        prop_as = property5.property_availabilities
        prop_as[7].update(reserved?: true)
      end

      let(:property1) { @property1.reload }
      let(:property2) { @property2.reload }
      let(:property3) { @property3.reload }
      let(:property4) { @property4.reload }
      let(:property5) { @property5.reload }

      it 'can chain all scopes together' do
        params = { location: { lat: 39.7392, long: -104.9903, radius: 25 }, guests: 5, dates: '01/05/2017-01/10/2017' }

        results = Property.search(params)

        expect(results.to_a.include?(property1)).to be_truthy
        expect(results.to_a.include?(property2)).to be_truthy

        expect(results.to_a.include?(property3)).to be_falsey
        expect(results.to_a.include?(property4)).to be_falsey
        expect(results.to_a.include?(property5)).to be_falsey
      end

      it 'can search when dates param is nil' do
        params = { location: { lat: 39.7392, long: -104.9903, radius: 25 }, guests: 5, dates: nil }

        results = Property.search(params)

        expect(results.to_a.include?(property1)).to be_truthy
        expect(results.to_a.include?(property2)).to be_truthy

        expect(results.to_a.include?(property3)).to be_falsey
        expect(results.to_a.include?(property4)).to be_falsey
        expect(results.to_a.include?(property5)).to be_falsey
      end

      it 'can search when guests param is nil' do
        params = { location: { lat: 39.7392, long: -104.9903, radius: 25 }, guests: nil, dates: nil }

        results = Property.search(params)

        expect(results.to_a.include?(property1)).to be_truthy
        expect(results.to_a.include?(property2)).to be_truthy
        expect(results.to_a.include?(property3)).to be_truthy

        expect(results.to_a.include?(property4)).to be_falsey
        expect(results.to_a.include?(property5)).to be_falsey
      end

      it 'can search when location param is nil' do
        params = { location: nil, guests: 5, dates: nil }

        results = Property.search(params)

        expect(results.to_a.include?(property1)).to be_truthy
        expect(results.to_a.include?(property2)).to be_truthy
        expect(results.to_a.include?(property5)).to be_truthy

        expect(results.to_a.include?(property3)).to be_falsey
        expect(results.to_a.include?(property4)).to be_falsey
      end

      it 'will return nil if all params are nil' do
        params = { location: nil, guests: nil, dates: nil }

        results = Property.search(params)

        expect(results).to be_falsey
      end
    end
  end
end