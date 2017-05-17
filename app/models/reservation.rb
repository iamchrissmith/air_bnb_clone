class Reservation < ApplicationRecord
  belongs_to :property
  belongs_to :user, foreign_key: "renter_id"
end
