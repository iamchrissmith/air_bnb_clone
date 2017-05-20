class Reservation < ApplicationRecord
  validates :total_price, :start_date, :end_date, :number_of_guests, :status, presence: true
  
  belongs_to :property
  belongs_to :renter, class_name: "User", foreign_key: "renter_id"

  enum status: %w(pending confirmed in_progress finished declined)
end
