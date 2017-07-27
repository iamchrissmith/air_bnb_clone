require 'rails_helper'

RSpec.describe "Properties API", type: :request do

  it "returns a 200 status along with random properties" do
    create_list(:property, 10)

    get "/api/v1/properties/properties.json"
    result = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(200)
    expect(result[:properties].count).to eq(10)
  end

  it "returns a 200 along with properties searched for" do
    create(:property, city: 'Denver')

    get "/api/v1/properties/properties.json", city: 'Denver'
    result = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(result[:properties].count).to eq(1)
    expect(result[:properties].first[:city]).to eq('Denver')
  end

  it "returns a 400 status if api call is bad" do
    create(:property, city: 'Denver')
    get "/api/v1/properties/properties.json", city: 'Boulder'

    expect(response).to have_http_status(200)
  end
end