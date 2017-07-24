class Api::V1::Reservations::MonthController < ApplicationController

  def index
    if params[:city]
      render json: Reservation.reservations_by_month_city(params[:city])
    else
      render json: Reservation.reservations_by_month
    end
  end

end
