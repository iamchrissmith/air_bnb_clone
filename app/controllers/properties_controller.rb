class PropertiesController < ApplicationController

  def index
    if params[:city].present? && params[:guests].present? && params[:check_in].present?
      @properties = Property.joins(:property_availabilities).merge(PropertyAvailability.available).where("number_of_guests >= ? AND property_availabilities.date = ? AND city LIKE ?", params[:guests], params[:check_in].to_date, "%#{params[:city]}%")
      @number_of_guests = params[:guests]
    elsif params[:city].present? && params[:guest].present?
      @properties = Property.where('city LIKE ? AND number_of_guests >= ?', "%#{params[:city]}%", params[:guests])
      @number_of_guests = params[:guests]
    elsif params[:check_in].present? && params[:guest].present?
      @properties = Property.joins(:property_availabilities).merge(PropertyAvailability.available).where("number_of_guests >= ? AND property_availabilities.date = ?", params[:guests], params[:check_in].to_date)
      @number_of_guests = params[:guests]
    elsif params[:check_in].present? && params[:city].present?
      @properties = Property.joins(:property_availabilities).merge(PropertyAvailability.available).where('city LIKE ? AND property_availabilities.date = ?', "%#{params[:city]}%", params[:check_in].to_date)
    elsif params[:check_in].present?
      @properties = Property.joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date = ?', params[:check_in].to_date)
      @date = params[:check_in]
    elsif params[:city].present?
      @properties = Property.where('city LIKE ?', "%#{params[:city]}%")
    elsif params[:guests].present?
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