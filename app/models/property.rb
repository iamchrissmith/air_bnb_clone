class Property < ApplicationRecord
  validates :name, :number_of_guests, :number_of_beds, :number_of_rooms, :description, :price_per_night, presence: true
  validates :address, :city, :state, :zip, :image_url, :status, presence: true

  belongs_to :room_type
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :reservations
  has_many :property_availabilities

  enum status: %w(pending active archived)
end
