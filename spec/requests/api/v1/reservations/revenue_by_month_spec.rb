require 'rails_helper'

describe 'total revenue by month endpoint' do
  before :all do
    denver_prop = create(:property, city: "Denver")
    tulsa_prop = create(:property, city: "Tulsa")
    12.times do |n|
      date = "2016-#{n+1}-1".to_date
      create(:reservation,
        start_date: date,
        end_date: (date + 1),
        property_id: denver_prop.id,
        total_price: "#{((n+1)*9.99)}")
      create(:reservation,
        start_date: date,
        end_date: (date + 1),
        property_id: tulsa_prop.id,
        total_price: "#{((n+1)*9.99)}")
    end
  end
  context "when user adds city param" do
    it "returns revenue totals per month" do
      city = "Denver"
      get "/api/v1/reservations/revenue_by_month", params: {city: city}

      expect(response).to be_success
      revenue = JSON.parse(response.body)

      expect(revenue).to be_a(Hash)
      expect(revenue.keys.count).to eq(12)
      expect(revenue["Jan-2016"]).to eq(per_month_rev(1))
      expect(revenue["Dec-2016"]).to eq(per_month_rev(12))
    end
  end
  context "when user doesn't add city param" do
    it "returns revenue totals per month for all cities" do
      get "/api/v1/reservations/revenue_by_month"

      expect(response).to be_success
      revenue = JSON.parse(response.body)

      expect(revenue).to be_a(Hash)
      expect(revenue.keys.count).to eq(12)
      expect(revenue["Jan-2016"]).to eq(per_month_rev(1*2))
      expect(revenue["Dec-2016"]).to eq(per_month_rev(12*2))
    end
  end
end
