class Reservation < ApplicationRecord
  belongs_to :property
  belongs_to :renter, class_name: "User", foreign_key: "renter_id"
end
