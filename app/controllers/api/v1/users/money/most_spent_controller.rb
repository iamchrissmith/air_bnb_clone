class Api::V1::Users::Money::MostSpentController < ApplicationController

  def index
    render json: User.most_money_spent(params[:limit])
  end
end
