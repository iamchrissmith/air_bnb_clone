require 'rails_helper'

RSpec.describe 'Properties API', type: :request do

  describe 'can return results within radius' do

    it 'can return properties wthin a radius of lat/long search' do
      valid1 = create(property:, name: 'Lakewood', lat: 39.7047095, long: -105.0813734)
      valid2 = create(property:, name: 'Aurora', lat: 39.7294319, long: -104.8319195)
      valid3 = create(property:, name: 'Boulder', lat: 40.0149856, long: -105.2705456)
      invalid1 = create(property:, name: 'Vail', lat: 39.6402638, long: -106.3741955)
      invalid2 = create(property:, name: 'Colorado Springs', lat: 38.8338816, long: -104.8213634)

      get "/api/v1/properties/search?lat=39.7392&long=-104.9903&radius=25"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(response.count).to eq(3)
      expect(response[0].name).to eq('Lakewood')
      expect(response[1].name).to eq('Aurora')
      expect(response[2].name).to eq('Boulder')

      expect(response[3]).to be_falsey
      expect(response[4]).to be_falsey
    end

    it 'can return properties wthin a radius of city state search' do
      valid1 = create(property:, name: 'Lakewood', city: 'Lakewood', state: 'CO')
      valid2 = create(property:, name: 'Aurora', city: 'Aurora', state: 'CO')
      valid3 = create(property:, name: 'Boulder', city: 'Boulder', state: 'CO')
      invalid1 = create(property:, name: 'Vail', city: 'Vail', state: 'CO')
      invalid2 = create(property:, name: 'Colorado Springs', city: 'Colorado Springs', state: 'CO')

      get "/api/v1/properties/search?city=Denver&state=CO&radius=25"
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(response.count).to eq(3)
      expect(response[0].name).to eq('Lakewood')
      expect(response[1].name).to eq('Aurora')
      expect(response[2].name).to eq('Boulder')

      expect(response[3]).to be_falsey
      expect(response[4]).to be_falsey
    end
  end

  describe 'can return results within a date range' do

    it 'can return properties with no reservations within date_range' do
      valid1 = create(property:, name: 'Lakewood')
      create(:property_availability, date: '1/07/2016', property: valid1)

      valid2 = create(property:, name: 'Aurora')
      create(:property_availability, date: '12/31/2016', property: valid2)

      invalid1 = create(property:, name: 'Boulder')
      create(:property_availability, date: '01/04/2017', property: invalid1)

      invalid2 = create(property:, name: 'Vail')
      create(:property_availability, date: '01/06/2017', property: invalid2)

      invalid3 = create(property:, name: 'Colorado Springs')
      create(:property_availability, date: '01/01/2017', property: invalid3)

      get "/api/v1/properties/search?dates=01/01/2017-01/6/2017"
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

  describe 'can return results by number of guests' do

    it 'can return properties that can handle number of guests' do
      valid1 = create(property:, name: 'Lakewood', number_of_guests: 8)
      valid2 = create(property:, name: 'Aurora', number_of_guests: 10)
      valid3 = create(property:, name: 'Boulder', number_of_guests: 6)
      invalid1 = create(property:, name: 'Vail', number_of_guests: 1)
      invalid2 = create(property:, name: 'Colorado Springs', number_of_guests: 3)

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