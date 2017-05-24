require 'rails_helper'

describe 'Users most properties' do
  it 'returns users that have the most properties listed' do
    user1, user2, user3 = create_list(:user, 3)

    create(:property, owner: user1)
    create(:property, owner: user1)
    create(:property, owner: user2)

    get "/api/v1/users/properties/most_properties?limit=2"

    expect(response).to be_success

    users = JSON.parse(response.body)

    expect(users.count).to eq(2)
    expect(users.first["id"]).to eq(user1.id)
  end
end