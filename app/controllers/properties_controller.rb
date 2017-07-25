class PropertiesController < ApplicationController

  def show
    @property = Property.find(params[:id])
    @weather = @property.get_weather
  end

  def index
      # @presenter = PropertyPresenter.new(params)
    if all_search_params
      @properties = Property.search_city_dates_guests(params[:city], params[:check_in].to_date, params[:check_out].to_date, params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif city_and_guest_search_params
      @properties = Property.search_city_guests(params[:city], params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
    elsif check_in_out_and_guest_search_params
      @properties = Property.search_dates_guests(params[:check_in].to_date, params[:check_out].to_date, params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif check_in_out_and_city_search_params
      @properties = Property.search_dates_city(params[:check_in].to_date, params[:check_out].to_date, params[:city]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif check_in_out_search_params
      @properties = Property.search_dates(params[:check_in].to_date, params[:check_out].to_date).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @check_in = params[:check_in].to_date
      @check_out = params[:check_out].to_date
    elsif city_search_param
      @properties = Property.search_city(params[:city]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
    elsif guest_search_param
      @properties = Property.search_guests(params[:guests]).paginate(:page => params[:page], :per_page => 20)
      @cities = @properties.pluck(:city).uniq
      @number_of_guests = params[:guests]
    # elsif !params[:check_in].present? || !params[:check_out].present?
    # if @presenter.any_search_param?
    #   @presenter.set_attributes
    elsif !params[:check_in].present? || !params[:check_out].present?
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
      redirect_to new_property_property_availability_path(@property)
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
      redirect_to edit_property_path(@property)
    end
  end

  private

    def properties_params
    params.require(:property).permit(:name, :number_of_guests, :number_of_beds, :number_of_rooms,
                                     :number_of_bathrooms, :description, :price_per_night, :address,
                                     :city, :state, :zip, :image_url, :room_type_id ,:check_in, :guests,
                                     :check_in_time, :check_out_time)
    end

    # def any_search_param?
    #   city_search_param || guest_search_param || check_in_out_search_params
    # end

    def all_search_params
      city_search_param && guest_search_param && check_in_out_search_params
    end

    def city_and_guest_search_params
      city_search_param && guest_search_param
    end

    def check_in_out_and_guest_search_params
      check_in_out_search_params && guest_search_param
    end

    def check_in_out_and_city_search_params
      check_in_out_search_params && city_search_param
    end

    def check_in_out_search_params
      params[:check_in].present? && params[:check_out].present?
    end

    def city_search_param
      params[:city].present?
    end

    def guest_search_param
      params[:guests].present?
    end
end
