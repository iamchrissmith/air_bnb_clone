class Api::V1::Properties::ReservationsController < ApiController

  before_action :get_property, only: :create

  def create
    reservation = @property.reservations.new(reservation_params)
    if reservation.save
      render json: {success:"Reservation Created", reservation: reservation}, status: 201
      create_trip_messaging
    else
      render json: {error: "Missing Parameters"}, status: 401
    end
  end

  private

    def reservation_params
      params.require(:reservation).permit(
        :start_date,
        :end_date,
        :number_of_guests,
        :renter_id
      )
    end

    def get_property
      @property = Property.find(params[:property_id])
    end

    def create_trip_messaging
      author = User.find(params[:reservation][:renter_id])
      receiver = User.joins(:properties)
                 .joins("INNER JOIN reservations ON reservations.property_id = properties.id")
                 .where("reservations.property_id = ?", params[:property_id]).first
      property = Property.joins(:reservations).find(params[:property_id])
      
      Conversation.new(title: "Trip to #{property.name}.", author_id: author.id, receiver_id: receiver.id)
    end
end
