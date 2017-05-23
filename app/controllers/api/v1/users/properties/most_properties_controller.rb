class Api::V1::Users::Properties::MostPropertiesController < ApplicationController

  def index
    render json: User.most_properties(params[:limit])
  end
end
