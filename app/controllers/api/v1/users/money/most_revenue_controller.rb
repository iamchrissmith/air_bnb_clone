class Api::V1::Users::Money::MostRevenueController < ApplicationController

  def index
    if params[:limit]
      render json: User.most_revenue(params[:limit])
    else
      render json: User.most_revenue
    end
  end
end