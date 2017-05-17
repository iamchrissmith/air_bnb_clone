class Property < ApplicationRecord
  belongs_to :room_type
  belongs_to :user, foreign_key: "owner_id"

  has_many :reservations
  has_many :property_availabilities
end
