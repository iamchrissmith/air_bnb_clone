require 'rails_helper'

describe 'Users most money spent' do
  it 'returns users that have spent the most money on rentals' do
    user1, user2, user3 = create_list(:user, 3)

    reservation1 = create(:reservation, renter: user1, total_price: 100.00)
    reservation2 = create(:reservation, renter: user2, total_price: 301.00)
    reservation3 = create(:reservation, renter: user3, total_price: 225.00)
    reservation4 = create(:reservation, renter: user3, total_price: 75.00)

    get "/api/v1/users/money/most_spent?limit=2"

    expect(response).to be_success

    users = JSON.parse(response.body)

    expect(users.count).to eq(2)
    expect(users.first["id"]).to eq(user2.id)
  end
end