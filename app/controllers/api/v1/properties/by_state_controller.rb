class Api::V1::Properties::ByStateController < ApplicationController
  def index
    render json: Property.by_state
  end
end
