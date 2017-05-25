require 'rails_helper'

describe 'highest revenue cities endpoint' do
  attr_reader :cities
  before :all do
    @cities = ["Denver", "Tulsa", "San Francisco",
      "New York", "Boston", "Seattle",
      "Washington D.C.", "Atlanta", "Durham",
      "Los Angeles", "San Antonio", "Portland",
      "Austin", "Nashville", "Raleigh"
    ]
    cities.each do |city|
      create(:property, city: city)
    end
    12.times do |n|
      date = "2016-#{n+1}-1".to_date
      15.times do |id|
        create(:reservation,
        start_date: date,
        end_date: (date + 1),
        property_id: rand(1..15),
        total_price: "#{((n+1)*9.99)}")
      end
    end
  end
  context "when user adds a limit, month, and year param" do
    it "returns top X cities by that year and month" do
      limit = 6; month = 4; year = 2016
      city_revenues = find_city_revenue(cities, limit, month, year)
      get "/api/v1/reservations/highest_revenue_cities",
        params: {limit: limit, month: month, year: year}

      expect(response).to be_success
      cities = JSON.parse(response.body)

      expect(cities).to be_an(Array)
      expect(cities.count).to eq(limit)
      expect(cities.first).to eq(city_revenues.first.first)
      expect(cities.last).to eq(city_revenues.last.first)
      expect(city_revenues.first.last).to be > (city_revenues.last.last)
    end
  end
  # context "when user adds a month params" do
  #   # when user adds a limit and year param
  #   # returns top X cities by that year
  #   # when user adds a limit and month param
  #   # returns top X cities by that month
  #   # when user adds a year and month param
  #   # returns top X cities by that year and month
  #   # when user adds a limit param only
  #   # returns top X cities of all time
  #   # when user adds a month param only
  #   # returns top X cities of all time for that month
  #   # when user adds a year param only
  #   # returns top X cities for all time for that year
  #   it "returns revenue totals per month for all cities" do
  #     get "/api/v1/reservations/revenue_by_month"
  #
  #     expect(response).to be_success
  #     revenue = JSON.parse(response.body)
  #
  #     expect(revenue).to be_a(Hash)
  #     expect(revenue.keys.count).to eq(12)
  #     expect(revenue["Jan-2016"]).to eq(per_month_rev(1*2))
  #     expect(revenue["Dec-2016"]).to eq(per_month_rev(12*2))
  #   end
  # end
end
