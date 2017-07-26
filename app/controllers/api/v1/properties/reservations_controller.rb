class Api::V1::Properties::ReservationsController < ApplicationController

  before_action :get_property, only: :create

  def create
    reservation = @property.reservations.new(reservation_params)
    if reservation.save
      render json: ["Reservation Created"], status: 201
    else
      render json: {error: "Missing Parameters"}, status: 400
    end
  end

  private

    def reservation_params
      params.require(:reservation).permit(
        :start_date,
        :end_date,
        :number_of_guests,
        :renter_id
      )
    end

    def get_property
      @property = Property.find(params[:property_id])
    end
end
