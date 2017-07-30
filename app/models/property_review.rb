class PropertyReview < ApplicationRecord
  belongs_to :property
  belongs_to :user
  belongs_to :reservation
end
