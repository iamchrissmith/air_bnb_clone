class PropertiesController < ApplicationController

  def show
    @property = Property.find(params[:id])
  end

  def index
    if params[:city].present? && params[:guests].present? && params[:check_in].present?
      @properties = Property.search_city_date_guests(params[:city], params[:check_in].to_date, params[:guests])
      @number_of_guests = params[:guests]
      @date = params[:check_in].to_date
    elsif params[:city].present? && params[:guests].present?
      @properties = Property.search_city_guests(params[:city], params[:guests])
      @number_of_guests = params[:guests]
    elsif params[:check_in].present? && params[:guests].present?
      @properties = Property.search_date_guests(params[:check_in].to_date, params[:guests])
      @number_of_guests = params[:guests]
      @date = params[:check_in].to_date
    elsif params[:check_in].present? && params[:city].present?
      @properties = Property.search_date_city(params[:check_in].to_date, params[:city])
      @date = params[:check_in].to_date
    elsif params[:check_in].present? && params[:check_out].present?
      @properties = Property.search_dates(params[:check_in].to_date, params[:check_out].to_date)
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif params[:city].present?
      @properties = Property.search_city(params[:city])
    elsif params[:guests].present?
      @properties = Property.search_guests(params[:guests])
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
