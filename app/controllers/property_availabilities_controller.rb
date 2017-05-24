class  PropertyAvailabilitiesController < ApplicationController

  before_action :set_property

  def index
    @property_availabilities = @property.property_availabilities.available
  end

  def new
    @property_availability = @property.property_availabilities.new()
  end

  def create
    @property_availabilities = @property.property_availabilities.set_availability(params[:first_available_date].to_date, params[:last_available_date].to_date)

    if @property_availabilities.count == ((params[:last_available_date].to_date - params[:first_available_date].to_date).to_i + 1)

      flash[:success] = "Your available dates have been set."
      redirect_to property_path(@property)
    else
      flash[:danger] = "Sorry! Something went wrong. Please try again."
      render :new
    end
  end

  def edit
    @property_availabilities = @property.property_availabilities
  end

  def update

    if params[:reserved] == "true"
      @property_availability.update(reserved?: true)
      if @property_availability.save
        flash[:success] = "Your available dates have been changed."
        redirect_to property_property_availability_path(@property)
      else
        render :index
      end
    else
     render :index
    end
  end

  def destroy
    @property_availability = @property.property_availabilities.find(params[:id])
    @property_availability.destroy
    redirect_to property_property_availabilities_path(@property)
  end

private

  def property_availability_params
    params.permit(:first_available_date, :last_available_date, :property_id)
  end

  def set_property
    @property = Property.find(params[:property_id])
  end

end
