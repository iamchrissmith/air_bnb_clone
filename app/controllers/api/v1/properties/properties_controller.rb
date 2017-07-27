class Api::V1::Properties::PropertiesController < ApplicationController
  def index
    @presenter = PropertyPresenter.new(params)
    @presenter.set_attributes
    if @presenter.properties.empty?
      render json: {status: 400}
    end
  end
end