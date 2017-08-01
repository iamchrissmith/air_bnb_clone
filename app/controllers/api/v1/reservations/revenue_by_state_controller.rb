class Api::V1::Reservations::RevenueByStateController < ApplicationController

  def index
    render json: StatePresenter.new(Reservation.revenue_by_state)
  end
end
