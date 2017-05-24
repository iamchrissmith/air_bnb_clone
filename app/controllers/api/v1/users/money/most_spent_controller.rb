class Api::V1::Users::Money::MostSpentController < ApplicationController

  def index
    if params[:limit]
      render json: User.most_money_spent(params[:limit])
    else
      render json: User.most_money_spent
    end
  end
end