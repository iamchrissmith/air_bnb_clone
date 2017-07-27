class ReservationToFinishedJob < ApplicationJob
  queue_as :default

  def perform
    Reservation.where('end_date <  ?', Date.today).update_all(status: 3)
  end
end
