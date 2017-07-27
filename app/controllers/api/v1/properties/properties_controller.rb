class Api::V1::Properties::PropertiesController < ApplicationController
  def index
    @presenter = PropertyPresenter.new(params)
    @presenter.set_attributes
    binding.pry 
    "hello"
  end
end