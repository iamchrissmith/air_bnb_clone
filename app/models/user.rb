class User < ApplicationRecord
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :authy_authenticatable, :database_authenticatable

  has_many :reservations, foreign_key: "renter_id"
  has_many :properties, foreign_key: "owner_id"
  has_many :identities

  enum role: %w(registered_user admin)

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_omniauth(auth_info)
    return from_google_omniauth(auth_info) if auth_info.provider == "google_oauth2"
    return from_fb_omniauth(auth_info) if auth_info.provider == "facebook"
  end

  def self.from_fb_omniauth(auth_info)
    where(email: auth_info[:info][:email]).first_or_create do |user|
      user.facebook_uid   = auth_info.uid
      user.first_name     = auth_info.info.name.split(' ')[0]
      user.last_name      = auth_info.info.name.split(' ')[1]
      user.email          = auth_info.info.email
      user.image_url      = auth_info.info.image
      user.facebook_token = auth_info.credentials.token
      user.password       = Devise.friendly_token[0,20]
    end
  end

  def self.from_google_omniauth(auth_info)
    where(email: auth_info[:info][:email]).first_or_create do |new_user|
      new_user.google_uid                   = auth_info.uid
      new_user.email                        = auth_info.info.email
      new_user.first_name                   = auth_info.info.first_name
      new_user.last_name                    = auth_info.info.last_name
      new_user.image_url                    = auth_info.info.image
      new_user.google_oauth_token           = auth_info.credentials.token
      new_user.google_oauth_expires_at      = auth_info.credentials.expires_at
      new_user.password                     = Devise.friendly_token[0,20]
    end
  end

  def self.reservations_by_night(limit = 10)
    self.find_by_sql("SELECT users.*, sum(reservations.end_date - reservations.start_date) AS nights
                      FROM users
                      JOIN reservations on users.id = reservations.renter_id
                      GROUP BY users.id
                      ORDER BY nights DESC
                      LIMIT(#{limit});")
  end

  def self.reservations_by_bookings(limit = 10)
    self.find_by_sql("SELECT users.*, sum(reservations.id) AS bookings
                      FROM users
                      JOIN reservations on users.id = reservations.renter_id
                      GROUP BY users.id
                      ORDER BY bookings DESC
                      LIMIT(#{limit});")
  end

  def self.most_properties(limit = 10)
    self.find_by_sql("SELECT users.*, sum(properties.id) AS props
                      FROM users
                      JOIN properties ON users.id = properties.owner_id
                      GROUP BY users.id
                      ORDER BY props DESC
                      LIMIT(#{limit});")
  end

  def self.most_money_spent(limit = 10)
    self.find_by_sql("SELECT users.*, sum(reservations.total_price) AS cost
                      FROM users
                      JOIN reservations ON users.id = reservations.renter_id
                      GROUP BY users.id
                      ORDER BY cost DESC
                      LIMIT(#{limit});")
  end

  def self.most_revenue(limit = 10)
    self.find_by_sql("SELECT users.*, sum(reservations.total_price) AS cost
                      FROM users
                      JOIN properties ON users.id = properties.owner_id
                      JOIN reservations ON properties.id = reservations.property_id
                      GROUP BY users.id
                      ORDER BY cost DESC
                      LIMIT(#{limit});")
  end
end
