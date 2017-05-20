class PropertiesController < ApplicationController

  def index
    if params[:city]
      @properties = Property.where('city LIKE ?', "%#{params[:city]}%")
    else
      @properties = Property.all
    end
  end

  private

  def properties_params
  params.require(:property).permit(:city, :check_in, :guests)
  end

end