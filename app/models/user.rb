class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reservations, foreign_key: "renter_id"
  has_many :properties, foreign_key: "owner_id"

  enum role: %w(registered_user admin)

  def full_name
    "#{first_name} #{last_name}"
  end
end
