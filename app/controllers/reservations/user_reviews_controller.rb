class Reservations::UserReviewsController < ApplicationController

  before_action :set_reservation, only: [:new, :create]

  def new
    @user_review = @reservation.build_user_review
  end

  def create
    if @reservation.create_user_review(review_params)
      redirect_to user_property_path(@reservation.property), success: 'Review Successfully Added'
    else
      render :new
    end
  end

  private

    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    def review_params
      params.require(:user_review)
            .permit(:user_id, :body, :rating)
            .merge(renter_id: @reservation.renter.id)
    end
end
