class Api::V1::Users::Reservations::BookingsController < ApplicationController

  def index
    render json: User.reservations_by_bookings(params[:limit])
  end

end