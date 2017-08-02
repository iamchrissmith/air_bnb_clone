class User::PropertiesController < ApplicationController
  def index
    @properties = current_user.properties
  end

  def show
    @property = Property.find(params[:id])
  end

end
