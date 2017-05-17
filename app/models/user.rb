class User < ApplicationRecord
  has_many :reservations
  has_many :properties

  enum role: %w(registered_user admin)
end
