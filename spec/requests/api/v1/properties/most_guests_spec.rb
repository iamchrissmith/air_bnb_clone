require 'rails_helper'

describe 'properties that accommodates most guests' do
  before :all do
    30.times do |n|
      if n.even?
        create(:property, number_of_guests: (n+1), city: "Denver")
      else
        create(:property, number_of_guests: (n+1), city: "Tulsa")
      end
    end
  end
  context "when user adds city param" do
    it "returns x number of properties" do
      limit = 6
      city = "Denver"
      get "/api/v1/properties/most_guests", params: {city: city, limit: limit}

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties).to be_an(Array)
      expect(properties.count).to eq(limit)
      expect(properties.first[:number_of_guests]).to eq(29)
      expect(properties.first[:city]).to eq(city)
      expect(properties.last[:number_of_guests]).to eq(19)
      expect(properties.last[:city]).to eq(city)
    end
    it "returns default (10) number of properties" do
      city = "Denver"
      get "/api/v1/properties/most_guests", params: {city: city}

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties.count).to eq(10)
      expect(properties.first[:number_of_guests]).to eq(29)
      expect(properties.first[:city]).to eq(city)
      expect(properties.last[:number_of_guests]).to eq(11)
      expect(properties.last[:city]).to eq(city)
    end
  end
  context "when user doesn't add city param" do
    it "returns x number of properties" do
      limit = 6
      get "/api/v1/properties/most_guests", params: {limit: limit}

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties.count).to eq(limit)
      expect(properties.first[:number_of_guests]).to eq(30)
      expect(properties.first[:city]).to eq("Tulsa")
      expect(properties.last[:number_of_guests]).to eq(25)
      expect(properties.last[:city]).to eq("Denver")
    end
    it "returns default (10) number of properties" do

      get "/api/v1/properties/most_guests"

      expect(response).to be_success
      properties = JSON.parse(response.body, symbolize_names: true)

      expect(properties.count).to eq(10)
      expect(properties.first[:number_of_guests]).to eq(30)
      expect(properties.first[:city]).to eq("Tulsa")
      expect(properties.last[:number_of_guests]).to eq(21)
      expect(properties.last[:city]).to eq("Denver")
    end
  end
end
