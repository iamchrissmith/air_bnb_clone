require 'rails_helper'

describe 'most expensive properties endpoint' do
  before :all do
    30.times do |n|
      if n.even?
        create(:property, price_per_night: (n+1)*20, city: "Denver")
      else
        create(:property, price_per_night: (n+1)*20, city: "Tulsa")
      end
    end
  end
  context "when user adds city param" do
    it "returns x number of properties" do
      limit = 6
      city = "Denver"
      get "/api/v1/properties/most_expensive", params: {city: city, limit: limit}

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties).to be_an(Array)
      expect(properties.count).to eq(limit)
      expect(properties.first[:price_per_night]).to eq((29*20.0).to_s)
      expect(properties.first[:city]).to eq(city)
      expect(properties.last[:price_per_night]).to eq((19*20.0).to_s)
      expect(properties.last[:city]).to eq(city)
    end
    it "returns default (10) number of properties" do
      city = "Denver"
      get "/api/v1/properties/most_expensive", params: {city: city}

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties.count).to eq(10)
      expect(properties.first[:price_per_night]).to eq((29*20.0).to_s)
      expect(properties.first[:city]).to eq(city)
      expect(properties.last[:price_per_night]).to eq((11*20.0).to_s)
      expect(properties.last[:city]).to eq(city)
    end
  end
  context "when user doesn't add city param" do
    it "returns x number of properties" do
      limit = 6
      get "/api/v1/properties/most_expensive", params: {limit: limit}

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties.count).to eq(limit)
      expect(properties.first[:price_per_night]).to eq((30*20.0).to_s)
      expect(properties.first[:city]).to eq("Tulsa")
      expect(properties.last[:price_per_night]).to eq((25*20.0).to_s)
      expect(properties.last[:city]).to eq("Denver")
    end
    it "returns default (10) number of properties" do

      get "/api/v1/properties/most_expensive"

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties.count).to eq(10)
      expect(properties.first[:price_per_night]).to eq((30*20.0).to_s)
      expect(properties.first[:city]).to eq("Tulsa")
      expect(properties.last[:price_per_night]).to eq((21*20.0).to_s)
      expect(properties.last[:city]).to eq("Denver")
    end
  end
end
