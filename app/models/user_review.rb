class UserReview < ApplicationRecord
  belongs_to :user
  belongs_to :reservation
  belongs_to :renter, class_name: "User"
end
