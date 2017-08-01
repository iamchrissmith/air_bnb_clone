require 'rails_helper'

RSpec.describe 'Properties by State API', type: :request do
  describe '/api/v1/properties/by_state' do
    let!(:property1) { create(:property, state: "CO") }
    let!(:property2) { create(:property, state: "CO") }
    let!(:property3) { create(:property, state: "WY") }
    it 'can return total properties by state' do
      get "/api/v1/properties/by_state"
      expect(response).to be_success
      expect(response.status).to eq(200)

      states = JSON.parse(response.body, symbolize_names: true)[:results]

      expect(states.count).to eq(2)
      expect(states[0][:state]).to eq("CO")
      expect(states[0][:total]).to eq(2)
      expect(states[1][:state]).to eq("WY")
      expect(states[1][:total]).to eq(1)
    end
  end
end
