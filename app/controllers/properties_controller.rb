class PropertiesController < ApplicationController

  def show
    @property = Property.find(params[:id])
    @weather = @property.get_weather
  end

  def index
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
end
