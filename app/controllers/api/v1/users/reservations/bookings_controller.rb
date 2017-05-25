class Api::V1::Users::Reservations::BookingsController < ApplicationController

  def index
    if params[:limit]
      render json: User.reservations_by_bookings(params[:limit])
    else
      render json: User.reservations_by_bookings
    end
  end

end