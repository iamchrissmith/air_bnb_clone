require 'rails_helper'

RSpec.describe ReservationStatusJob, type: :job do
  let!(:in_progress_reservation) { create(:reservation, start_date: Date.yesterday, end_date: Date.tomorrow) }
  let!(:finished_reservation) { create(:reservation, end_date: Date.yesterday) }
  it 'sets a current reservation to in-progress' do
    expect(in_progress_reservation.status).to eq 'confirmed'
    ReservationStatusJob.perform_now
    in_progress_reservation.reload
    expect(in_progress_reservation.status).to eq 'in_progress'
  end

  it 'sets a past reservation to finished' do
    expect(finished_reservation.status).to eq 'confirmed'
    ReservationStatusJob.perform_now
    finished_reservation.reload
    expect(finished_reservation.status).to eq 'finished'
  end
end
