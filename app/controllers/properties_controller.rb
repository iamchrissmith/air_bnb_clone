class PropertiesController < ApplicationController

  def index
    if !params[:city].empty? && !params[:guests].empty?
      @properties = Property.where('city LIKE ? AND number_of_guests >= ?', "%#{params[:city]}%", params[:guests])
      @number_of_guests = params[:guests]
    elsif !params[:city].empty?
      @properties = Property.where('city LIKE ?', "%#{params[:city]}%")
    elsif !params[:guests].empty?
      @properties = Property.where("number_of_guests >= ?", params[:guests])
      @number_of_guests = params[:guests]
    else
      @properties = Property.all
    end
  end

  private

  def properties_params
  params.require(:property).permit(:city, :check_in, :guests)
  end

end