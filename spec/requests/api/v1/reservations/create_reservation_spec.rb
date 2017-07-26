require 'rails_helper'

describe 'Create Reservation API' do
  context 'POST /api/v1/reservations' do
    let(:user) { create(:user) }
    let(:property) { create(:property) }
    let(:availability_start) { create(:property_availability, reserved?: false, property: property) }
    let(:availability_end) { create(:property_availability, reserved?: false, property: property, date: availability_start.date+1) }

    it 'creates a new reservation' do
      params = {reservation: {
        start_date: availability_start.date,
        end_date: availability_end.date,
        number_of_guests: 1,
        renter_id: user.id
      }}

      expect{
        post "/api/v1/properties/#{property.id}/reservations",
              params: params
      }.to change{Reservation.count}.by(1)
      expect(response).to be_success
    end

    context 'without a required param' do
      it 'returns an error message and code' do
        params = {reservation: {
          start_date: availability_start.date,
          end_date: availability_end.date,
          # number_of_guests: 1,
          renter_id: user.id
        }}

        post "/api/v1/properties/#{property.id}/reservations",
              params: params
        expect(response).not_to be_success
        expect(JSON.parse(response.body)["error"]).to eq "Missing Parameters"
      end
    end

    context 'when the property is not available' do
      it 'returns an error that the property is not available'
    end

    context 'when the user is not logged in' do
      it 'displays a not authorized message'
    end
  end
end
