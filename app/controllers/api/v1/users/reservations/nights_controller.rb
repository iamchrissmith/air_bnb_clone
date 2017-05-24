class Api::V1::Users::Reservations::NightsController < ApplicationController

  def index
    if params[:limit]
      render json: User.reservations_by_night(params[:limit])
    else
      render json: User.reservations_by_night
    end
  end

end