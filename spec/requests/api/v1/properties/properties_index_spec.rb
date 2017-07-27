require 'rails_helper'

RSpec.describe "Properties API", type: :request do

  it "returns a 200 status along with random properties" do
    create_list(:property, 10)

    get "/api/v1/properties/properties.json"
    result = JSON.parse(response.body, symbolize_names: true)
    binding.pry
    expect(response).to have_http_status(200)
    expect(result).to eq(1)
  end

  xit "returns a 200 along with properties searched for" do

  end

  xit "returns a 400 status if api call is bad" do

  end
end