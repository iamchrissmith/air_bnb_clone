class Api::V1::Properties::MostGuestsController < ApplicationController

  def index
    render json: Property.most_guests(search_params)
  end

  private

    def search_params
      params.permit(:city, :limit)
    end

end
