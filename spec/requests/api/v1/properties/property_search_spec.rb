require 'rails_helper'

RSpec.describe 'Properties API', type: :request do

  before(:all) do
    @property1 = create(:property, name: 'Lakewood', address: '9227 W Mississippi Ave', city: 'Lakewood', state: 'CO')
    @property2 = create(:property, name: 'Aurora', address: '19599 E Bails Pl', city: 'Aurora', state: 'CO')
    @property3 = create(:property, name: 'Boulder', address: '880 33rd St', city: 'Boulder', state: 'CO')
    @property4 = create(:property, name: 'Vail', address: '245 Forest Rd', city: 'Vail', state: 'CO')
    @property5 = create(:property, name: 'Colorado Springs', address: '1 Olympic Plaza', city: 'Colorado Springs', state: 'CO')
  end

  let(:property1) { @property1.reload }
  let(:property2) { @property2.reload }
  let(:property3) { @property3.reload }
  let(:property4) { @property4.reload }
  let(:property5) { @property5.reload }

  describe 'can return results within a radius' do

    it 'can return properties wthin a radius of lat/long search' do
      get "/api/v1/properties/search?location[lat=39.7392&location[long=-104.9903&location[radius=25"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(result.count).to eq(3)
      expect(result.one? { |prop| prop[:name] == 'Lakewood' } ).to be_truthy
      expect(result.one? { |prop| prop[:name] == 'Aurora' } ).to be_truthy
      expect(result.one? { |prop| prop[:name] == 'Boulder' } ).to be_truthy

      expect(result.any? { |prop| prop[:name] == 'Colorado Springs' } ).to be_falsey
      expect(result.any? { |prop| prop[:name] == 'Vail' } ).to be_falsey
    end

    it 'can return properties wthin a radius of city state search' do
      valid1 = create(:property, name: 'Lakewood', city: 'Lakewood', state: 'CO')
      valid2 = create(:property, name: 'Aurora', city: 'Aurora', state: 'CO')
      valid3 = create(:property, name: 'Boulder', city: 'Boulder', state: 'CO')
      invalid1 = create(:property, name: 'Vail', city: 'Vail', state: 'CO')
      invalid2 = create(:property, name: 'Colorado Springs', city: 'Colorado Springs', state: 'CO')

      get "/api/v1/properties/search?location[city=Denver&location[state=CO&location[radius=25"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result.count).to eq(3)
      expect(result.one? { |prop| prop[:name] == 'Lakewood' } ).to be_truthy
      expect(result.one? { |prop| prop[:name] == 'Aurora' } ).to be_truthy
      expect(result.one? { |prop| prop[:name] == 'Boulder' } ).to be_truthy

      expect(result.any? { |prop| prop[:name] == 'Colorado Springs' } ).to be_falsey
      expect(result.any? { |prop| prop[:name] == 'Vail' } ).to be_falsey
    end
  end

  describe 'can return results within a date range' do

    it 'can return properties with no reservations within date_range' do
      property1 = create(:property, name: 'Lakewood')
      property2 = create(:property, name: 'Aurora')
      property3 = create(:property, name: 'Boulder')
      property4 = create(:property, name: 'Vail')
      property5 = create(:property, name: 'Colorado Springs')

      [property1, property2, property3, property4, property5].each do |property|
        property.property_availabilities << PropertyAvailability.set_availability(DateTime.new(2017,1,1), DateTime.new(2017,1,14))
      end

      prop_as = property1.property_availabilities
      prop_as[3].update(reserved: true)
      prop_as[10].update(reserved: true)

      prop_as = property2.property_availabilities
      prop_as[0..2].each { |pa| pa.update(reserved: true) }
      prop_as[12..13].each { |pa| pa.update(reserved: true) }

      prop_as = property3.property_availabilities
      prop_as[4].update(reserved: true)

      prop_as = property4.property_availabilities
      prop_as[9].update(reserved: true)

      prop_as = property5.property_availabilities
      prop_as[7].update(reserved: true)

      get "/api/v1/properties/search?dates=01/05/2017-01/10/2017"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result.count).to eq(2)

      expect(result.one? { |prop| prop[:name] == 'Lakewood' } ).to be_truthy
      expect(result.one? { |prop| prop[:name] == 'Aurora' } ).to be_truthy
      expect(result.any? { |prop| prop[:name] == 'Boulder' } ).to be_falsey
      expect(result.any? { |prop| prop[:name] == 'Colorado Springs' } ).to be_falsey
      expect(result.any? { |prop| prop[:name] == 'Vail' } ).to be_falsey
    end
  end

  describe 'can return results by number of guests' do

    it 'can return properties that can handle number of guests' do
      valid1 = create(:property, name: 'Lakewood', number_of_guests: 8)
      valid2 = create(:property, name: 'Aurora', number_of_guests: 10)
      valid3 = create(:property, name: 'Boulder', number_of_guests: 6)
      invalid1 = create(:property, name: 'Vail', number_of_guests: 1)
      invalid2 = create(:property, name: 'Colorado Springs', number_of_guests: 3)

      get "/api/v1/properties/search?guests=5"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result.count).to eq(3)
      expect(result.one? { |prop| prop[:name] == 'Lakewood' } ).to be_truthy
      expect(result.one? { |prop| prop[:name] == 'Aurora' } ).to be_truthy
      expect(result.one? { |prop| prop[:name] == 'Boulder' } ).to be_truthy

      expect(result.any? { |prop| prop[:name] == 'Colorado Springs' } ).to be_falsey
      expect(result.any? { |prop| prop[:name] == 'Vail' } ).to be_falsey
    end
  end
end