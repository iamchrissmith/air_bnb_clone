class Api::V1::Properties::ByStateController < ApplicationController
  def index
    render json: StatePresenter.new(Property.by_state)
  end
end
