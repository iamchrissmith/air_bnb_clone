class Api::V1::Users::Properties::MostPropertiesController < ApplicationController

  def index
    if params[:limit]
      render json: User.most_properties(params[:limit])
    else
      render json: User.most_properties
    end
  end
end
