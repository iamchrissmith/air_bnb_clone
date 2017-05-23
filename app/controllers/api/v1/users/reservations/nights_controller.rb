class Api::V1::Users::Reservations::NightsController < ApplicationController

  def index
    render json: User.reservations_by_night(params[:limit])
  end

end