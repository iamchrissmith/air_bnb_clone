class PropertiesController < ApplicationController

  def index
    if params[:city].present?
      @properties = Property.where('city LIKE ?', "%#{params[:city]}%")
    elsif params[:check_in].present?
      @properties = PropertyAvailability.find_available_properties((params[:check_in]).to_date)
    else
      @properties = Property.all
    end
  end

  private

  def properties_params
  params.require(:property).permit(:city, :check_in, :guests)
  end

end