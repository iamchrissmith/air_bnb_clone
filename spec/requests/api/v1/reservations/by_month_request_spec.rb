require 'rails_helper'

describe 'Reservations by month' do
  it 'returns number of reservations for each month' do
    Timecop.freeze(Time.local(2017, 7, 1, 10, 00, 00)) do
      reservation1 = create(:reservation, start_date: Date.today)
      reservation2 = create(:reservation, start_date: Date.today+1.month)
      reservation3 = create(:reservation, start_date: Date.today+3)
      reservation4 = create(:reservation, start_date: Date.tomorrow)

      get "/api/v1/reservations/by_month"

      expect(response).to be_success
      reservations = JSON.parse(response.body)

      next_month = (Date.today+1.month).strftime("%B")

      expect(reservations.count).to eq(2)
      expect(reservations.first['month']).to eq(next_month)
      expect(reservations.first['count']).to eq(1)
    end
  end

  it 'returns number of reservations for each month for a city' do
    Timecop.freeze(Time.local(2017, 7, 1, 10, 00, 00)) do
      property1 = create(:property, city: 'Denver')
      property2 = create(:property, city: 'San Francisco')
      reservation_p1_this_month = create(:reservation, property_id: property1.id, start_date: Date.today)
      reservation_p1_next_month = create(:reservation, property_id: property1.id, start_date: Date.today+1.month)
      reservation_p1_this_month2 = create(:reservation, property_id: property1.id, start_date: Date.tomorrow)

      other_property_reservation = create(:reservation, property_id: property2.id, start_date: Date.yesterday)

      get "/api/v1/reservations/by_month?city=Denver"

      expect(response).to be_success
      reservations = JSON.parse(response.body)

      next_month = (Date.today+1.month).strftime("%B")
      this_month = Date.today.strftime("%B")

      expect(reservations.count).to eq(2)
      expect(reservations.first['month']).to eq(next_month)
      expect(reservations.first['count']).to eq(1)
      expect(reservations.second['month']).to eq(this_month)
      expect(reservations.second['count']).to eq(2)
    end
  end
end
