class User < ApplicationRecord
  attr_accessor :login

  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :database_authenticatable

  has_many :reservations, foreign_key: 'renter_id'

  has_many :properties, foreign_key: "owner_id"
  has_many :messages
  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id'
  has_many :properties, foreign_key: 'owner_id'
  has_many :property_reviews
  has_many :user_reviews

  enum role: %w[registered_user admin]

  validates :username, uniqueness: true, allow_nil: true, case_sensitive: false
  validates_format_of :username, with: /\A^[a-zA-Z0-9_\.]*$\z/, multiline: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def owner?
    !properties.empty?
  end

  def owner_of?(property)
    properties.includes? property
  end

  def reviewed_property?(reservation)
    reservation.id.in? property_reviews.pluck(:reservation_id)
  end

  def reviewed_renter?(request)
    request.id.in? user_reviews.pluck(:reservation_id)
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

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
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
    self.find_by_sql(["SELECT users.*, sum(reservations.end_date - reservations.start_date) AS nights
                      FROM users
                      JOIN reservations on users.id = reservations.renter_id
                      GROUP BY users.id
                      ORDER BY nights DESC
                      LIMIT ?;", limit])
  end

  def self.reservations_by_bookings(limit = 10)
    self.find_by_sql(["SELECT users.*, sum(reservations.id) AS bookings
                      FROM users
                      JOIN reservations on users.id = reservations.renter_id
                      GROUP BY users.id
                      ORDER BY bookings DESC
                      LIMIT ?", limit])
  end

  def self.most_properties(limit = 10)
    self.find_by_sql(["SELECT users.*, sum(properties.id) AS props
                      FROM users
                      JOIN properties ON users.id = properties.owner_id
                      GROUP BY users.id
                      ORDER BY props DESC
                      LIMIT(?);", limit])
  end

  def self.most_money_spent(limit = 10)
    self.find_by_sql(["SELECT users.*, sum(reservations.total_price) AS cost
                      FROM users
                      JOIN reservations ON users.id = reservations.renter_id
                      GROUP BY users.id
                      ORDER BY cost DESC
                      LIMIT(?);", limit])
  end

  def self.most_revenue(limit = 10)
    self.find_by_sql(["SELECT users.*, sum(reservations.total_price) AS cost
                      FROM users
                      JOIN properties ON users.id = properties.owner_id
                      JOIN reservations ON properties.id = reservations.property_id
                      GROUP BY users.id
                      ORDER BY cost DESC
                      LIMIT(?);", limit])
  end

  protected

    def self.send_reset_password_instructions attributes = {}
      recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
      recoverable.send_reset_password_instructions if recoverable.persisted?
      recoverable
    end

    def self.find_recoverable_or_initialize_with_errors required_attributes, attributes, error = :invalid
      (case_insensitive_keys || []).each {|k| attributes[k].try(:downcase!)}

      attributes = attributes.slice(*required_attributes)
      attributes.delete_if {|_key, value| value.blank?}

      if attributes.size == required_attributes.size
        if attributes.key?(:login)
          login = attributes.delete(:login)
          record = find_record(login)
        else
          record = where(attributes).first
        end
      end

      unless record
        record = new

        required_attributes.each do |key|
          value = attributes[key]
          record.send("#{key}=", value)
          record.errors.add(key, value.present? ? error : :blank)
        end
      end
      record
    end

    def self.find_record login
      where(["username = :value OR email = :value", {value: login}]).first
    end
end
