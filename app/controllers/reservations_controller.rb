class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:update]

  def update
    if @reservation.update(status: params[:res_action])
      PropertyAvailability.set_reserved(@reservation.property_id, @reservation.start_date, @reservation.end_date)
      redirect_to user_property_path(@reservation.property)
    else
      redirect_to user_property_path(@reservation.property), warning: "Reservation not updated"
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
end
