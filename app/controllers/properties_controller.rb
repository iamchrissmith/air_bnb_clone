class PropertiesController < ApplicationController

  def show
    @property = Property.find(params[:id])
  end

  def index
    if params[:city].present? && params[:guests].present? && params[:check_in].present? && params[:check_out].present?
      @properties = Property.search_city_dates_guests(params[:city], params[:check_in].to_date, params[:check_out].to_date, params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif params[:city].present? && params[:guests].present?
      @properties = Property.search_city_guests(params[:city], params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
    elsif params[:check_in].present? && params[:check_out].present? && params[:guests].present?
      @properties = Property.search_dates_guests(params[:check_in].to_date, params[:check_out].to_date, params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif params[:check_in].present? && params[:check_out].present? && params[:city].present?
      @properties = Property.search_dates_city(params[:check_in].to_date, params[:check_out].to_date, params[:city]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif params[:check_in].present? && params[:check_out].present?
      @properties = Property.search_dates(params[:check_in].to_date, params[:check_out].to_date).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif params[:city].present?
      @properties = Property.search_city(params[:city]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
    elsif params[:guests].present?
      @properties = Property.search_guests(params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
    elsif params[:check_in].present? && !params[:check_out].present? || !params[:check_in].present? && params[:check_out].present?
      flash[:danger] = "You must select both a check-in & check-out date. Please try again."
      redirect_to root_path
    else
      @properties = Property.all.paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
    end
  end

  def new
    @room_types = RoomType.all
    @property = Property.new
  end

  def create
    @property = current_user.properties.new(properties_params)
    @room_types = RoomType.all
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
