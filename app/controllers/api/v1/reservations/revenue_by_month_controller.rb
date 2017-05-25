class Api::V1::Reservations::RevenueByMonthController < ApplicationController

  def index
    render json: Reservation.revenue_by_month(search_params)
  end

  private

    def search_params
      params.permit(:city)
    end

end
