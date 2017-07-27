class User::PropertiesController < ApplicationController
  def index
    @properties = current_user.properties
  end
end
