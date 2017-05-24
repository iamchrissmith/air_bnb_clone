class Api::V1::Properties::MostExpensiveController < ApplicationController

  def index
    render json: Property.most_expensive(search_params)
  end

  private

    def search_params
      params.permit(:city, :limit)
    end

end
