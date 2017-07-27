require 'rails_helper'

RSpec.describe ReservationToFinishedJob, type: :job do
  let!(:reservation) { create(:reservation, end_date: Date.yesterday) }
  it 'sets a past reservation to finished' do
    expect(reservation.status).to eq 'confirmed'
    ReservationToFinishedJob.perform_now
    reservation.reload
    expect(reservation.status).to eq 'finished'
  end
end
