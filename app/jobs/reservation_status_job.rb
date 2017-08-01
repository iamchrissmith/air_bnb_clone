class ReservationStatusJob < ApplicationJob
  queue_as :default

  def perform
    Reservation.where('start_date <  ?', Date.today).where('end_date >  ?', Date.today).update_all(status: 2)
    Reservation.where('end_date <  ?', Date.today).update_all(status: 3)
  end
end
