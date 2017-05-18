class User < ApplicationRecord
  has_many :reservations, foreign_key: "renter_id"
  has_many :properties, foreign_key: "owner_id"

  enum role: %w(registered_user admin)

end
