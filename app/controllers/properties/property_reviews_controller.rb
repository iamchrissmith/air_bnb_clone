class Properties::PropertyReviewsController < ApplicationController

  before_action :set_property, only: [:new, :create]

  def new
    @property_review = @property.property_reviews.new()
  end

  def create
    binding.pry
    if @property.property_reviews.create(review_params)
      redirect_to @property, success: "Review Successfully Added"
    else
      render :new
    end
  end

  private
    def set_property
      @property = Property.find(params[:property_id])
    end

    def review_params
      params.require(:property_review).permit(:user_id, :body, :rating)
    end
end
