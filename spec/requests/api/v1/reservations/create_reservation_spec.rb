require 'rails_helper'

describe 'Create Reservation API' do
  context 'POST /api/v1/reservations/new' do
    let(:user) { create(:user) }
    let(:property) { create(:property) }
    let(:availability_start) { create(:property_availability, reserved?: false, property: property) }
    let(:availability_end) { create(:property_availability, reserved?: false, property: property, date: availability_start.date+1) }

    it 'creates a new reservation' do
      params = {
        price: "10",
        start_date: availability_start.date,
        end_date: availability_end.date,
        number_of_guests: 1,
        renter_id: user.id
      }

      expect{
        post "/api/v1/properties/#{property.id}/reservations/new", params.to_json, format: :json
      }.to change{Reservation.count}.from(0).to(1)
    end

    context 'when the property is not available' do
      it 'returns an error that the property is not available'
    end

    context 'when the user is not logged in' do
      it 'displays a not authorized message'
    end
  end
end
