require 'rails_helper'

describe 'Users most revenue' do
  it 'returns users that have made the most money as owners of rentals' do
    user1, user2, user3 = create_list(:user, 3)
    create(:property, owner: user1)
    create(:property, owner: user2)
    create(:property, owner: user3)

    reservation1 = create(:reservation, property_id: 1, total_price: 100.00)
    reservation2 = create(:reservation, property_id: 2, total_price: 301.00)
    reservation3 = create(:reservation, property_id: 3, total_price: 225.00)
    reservation4 = create(:reservation, property_id: 2, total_price: 75.00)

    get "/api/v1/users/money/most_revenue?limit=2"

    expect(response).to be_success

    users = JSON.parse(response.body)

    expect(users.count).to eq(2)
    expect(users.first["id"]).to eq(user2.id)
  end
end