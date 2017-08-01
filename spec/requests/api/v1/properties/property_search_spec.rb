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

    xit 'can return properties wthin a radius of lat/long search' do
      get "/api/v1/properties/search?lat=39.7392&long=-104.9903&radius=25"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(result.count).to eq(3)
      expect(result[0][:name]).to eq('Lakewood')
      expect(result[1][:name]).to eq('Aurora')
      expect(result[2][:name]).to eq('Boulder')

      expect(result[3]).to be_falsey
      expect(result[4]).to be_falsey
    end

    xit 'can return properties wthin a radius of city state search' do
      valid1 = create(:property, name: 'Lakewood', city: 'Lakewood', state: 'CO')
      valid2 = create(:property, name: 'Aurora', city: 'Aurora', state: 'CO')
      valid3 = create(:property, name: 'Boulder', city: 'Boulder', state: 'CO')
      invalid1 = create(:property, name: 'Vail', city: 'Vail', state: 'CO')
      invalid2 = create(:property, name: 'Colorado Springs', city: 'Colorado Springs', state: 'CO')

      get "/api/v1/properties/search?city=Denver&state=CO&radius=25"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result.count).to eq(3)
      expect(result[0][:name]).to eq('Lakewood')
      expect(result[1][:name]).to eq('Aurora')
      expect(result[2][:name]).to eq('Boulder')

      expect(result[3]).to be_falsey
      expect(result[4]).to be_falsey
    end
  end

  describe 'can return results within a date range' do

    it 'can return properties with no reservations within date_range' do
      valid1 = create(:property, name: 'Lakewood')
      create(:property_availability, date: DateTime.new(2016,7,1), property: valid1)

      valid2 = create(:property, name: 'Aurora')
      create(:property_availability, date: DateTime.new(2016,12,31), property: valid2)

      invalid1 = create(:property, name: 'Boulder')
      create(:property_availability, date: DateTime.new(2017,4,1), property: invalid1)

      invalid2 = create(:property, name: 'Vail')
      create(:property_availability, date: DateTime.new(2017,6,1), property: invalid2)

      invalid3 = create(:property, name: 'Colorado Springs')
      create(:property_availability, date: DateTime.new(2017,1,1), property: invalid3)

      get "/api/v1/properties/search?dates=01/01/2017-01/06/2017"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response.count).to eq(2)
      expect(response[0][:name]).to eq('Lakewood')
      expect(response[1][:name]).to eq('Aurora')

      expect(response[2]).to be_falsey
      expect(response[3]).to be_falsey
      expect(response[4]).to be_falsey
    end
  end

  xdescribe 'can return results by number of guests' do

    it 'can return properties that can handle number of guests' do
      valid1 = create(:property, name: 'Lakewood', number_of_guests: 8)
      valid2 = create(:property, name: 'Aurora', number_of_guests: 10)
      valid3 = create(:property, name: 'Boulder', number_of_guests: 6)
      invalid1 = create(:property, name: 'Vail', number_of_guests: 1)
      invalid2 = create(:property, name: 'Colorado Springs', number_of_guests: 3)

      get "/api/v1/properties/search?guests=5"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response.count).to eq(3)
      expect(response[0][:name]).to eq('Aurora')
      expect(response[1][:name]).to eq('Lakewood')
      expect(response[2][:name]).to eq('Boulder')

      expect(response[3]).to be_falsey
      expect(response[4]).to be_falsey
    end
  end
end