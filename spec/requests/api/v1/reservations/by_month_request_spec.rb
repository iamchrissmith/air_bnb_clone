require 'rails_helper'

describe 'Reservations by month' do
  it 'returns number of reservations for each month' do

    reservation1 = create(:reservation, start_date: Date.today)
    reservation2 = create(:reservation, start_date: Date.today+30)
    reservation3 = create(:reservation, start_date: Date.yesterday)
    reservation4 = create(:reservation, start_date: Date.tomorrow)

    get "/api/v1/reservations/by_month"

    expect(response).to be_success
    reservations = JSON.parse(response.body)

    expect(reservations.count).to eq(2)
    expect(reservations.first['month']).to eq('June     ')
    expect(reservations.first['count']).to eq(1)
  end

  it 'returns number of reservations for each month for a city' do
    property1 = create(:property, city: 'Denver')
    property2 = create(:property, city: 'San Francisco')
    reservation1 = create(:reservation, property_id: property1.id, start_date: Date.today)
    reservation2 = create(:reservation, property_id: property1.id, start_date: Date.today+30)
    reservation3 = create(:reservation, property_id: property2.id, start_date: Date.yesterday)
    reservation4 = create(:reservation, property_id: property1.id, start_date: Date.tomorrow)

    get "/api/v1/reservations/by_month?city=Denver"

    expect(response).to be_success
    reservations = JSON.parse(response.body)

    expect(reservations.count).to eq(2)
    expect(reservations.first['month']).to eq('June     ')
    expect(reservations.first['count']).to eq(1)
    expect(reservations.second['month']).to eq('May      ')
    expect(reservations.second['count']).to eq(2)
  end
end