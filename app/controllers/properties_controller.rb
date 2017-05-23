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
    elsif params[:check_in].present?
      @properties = Property.search_date(params[:check_in].to_date)
      @date = params[:check_in].to_date
    elsif params[:city].present?
      @properties = Property.search_city(params[:city])
    elsif params[:guests].present?
      @properties = Property.search_guests(params[:guests])
      @number_of_guests = params[:guests]
    else
      @properties = Property.all
    end
  end

  def new
    @room_types = RoomType.all
    @property = Property.new
  end

  def create
    @room_types = RoomType.all
    @property = current_user.properties.new(properties_params)
    if @property.save
      flash[:success] = "Your rental property has been submitted for approval. You will be contacted as soon as your property is approved!"

      redirect_to property_path(@property)
    else
      flash[:danger] = "Sorry! Something went wrong. Please try again."
      render :new
    end
  end

  def edit
    @room_types = RoomType.all
    @property = current_user.properties.find(params[:id])
  end

  def update
    @property = current_user.properties.find(params[:id])
    @property.update(properties_params)
    if @property.save
      flash[:success] = "Your edits have beeen submitted for approval. You will receive a notice when property is updated."
      redirect_to property_path(@property)
    else
      render :edit
    end
  end

  private

    def properties_params
    params.require(:property).permit(:name, :number_of_guests, :number_of_beds, :number_of_rooms,
                                     :number_of_bathrooms, :description, :price_per_night, :address,
                                     :city, :state, :zip, :image_url, :room_type_id ,:check_in, :guests,
                                     :check_in_time, :check_out_time)
    end

end
