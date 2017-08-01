require 'rails_helper'

RSpec.describe 'Revenue by State API', type: :request do
  describe '/api/v1/reservations/revenue_by_state' do
    let(:date) { "2016-1-1".to_date }
    let(:property1) { create(:property, state: "CO", price_per_night: 9.99) }
    let(:property2) { create(:property, state: "WY", price_per_night: 9.99) }

    let!(:reservation1_p1) { create(:reservation, property: property1, start_date: date,
    end_date: (date + 1)) }
    let!(:reservation2_p1) { create(:reservation, property: property1, start_date: date,
    end_date: (date + 1)) }
    let!(:reservation1_p2) { create(:reservation, property: property2, start_date: date,
    end_date: (date + 1)) }

    it "can return total revenue by state" do
      get "/api/v1/reservations/revenue_by_state"
      expect(response).to be_success
      expect(response.status).to eq(200)

      states = JSON.parse(response.body, symbolize_names: true)[:results]
      expect(states.count).to eq(2)
      expect(states[0][:state]).to eq("CO")
      expect(states[0][:total]).to eq("#{9.99*2}")
      expect(states[1][:state]).to eq("WY")
      expect(states[1][:total]).to eq("9.99")
    end
  end
end
