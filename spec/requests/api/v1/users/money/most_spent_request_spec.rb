require 'rails_helper'

describe 'Users most money spent' do
  it 'returns users that have spent the most money on rentals' do
    user1, user2, user3 = create_list(:user, 3)

    reservation1 = create(:reservation, renter: user1)
    reservations_user2 = create_list(:reservation, 4, renter: user2)
    reservations_user3 = create_list(:reservation, 3, renter: user3)

    get "/api/v1/users/money/most_spent?limit=2"

    expect(response).to be_success

    users = JSON.parse(response.body)

    expect(users.count).to eq(2)
    expect(users.first["id"]).to eq(user2.id)
    expect(users.last["id"]).to eq(user3.id)
  end
end
