class Reservations::PropertyReviewsController < ApplicationController

  before_action :set_reservation, only: [:new, :create]

  def new
    @property_review = @reservation.build_property_review()
  end

  def create
    # binding.pry
    if @reservation.create_property_review(review_params)
      redirect_to @reservation.property, success: "Review Successfully Added"
    else
      render :new
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    def review_params
      params.require(:property_review).permit(:user_id, :body, :rating).merge(property_id: @reservation.property.id)
    end
end
