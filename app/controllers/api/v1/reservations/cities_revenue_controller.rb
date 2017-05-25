class Api::V1::Reservations::CitiesRevenueController < ApplicationController

  def index
    render json: Property.highest_revenue_cities(search_params)
  end


  private

    def search_params
      params.permit(:limit, :month, :year)
    end

end
