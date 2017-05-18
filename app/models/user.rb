class User < ApplicationRecord
  has_many :reservations, foreign_key: "renter_id"
  has_many :properties, foreign_key: "owner_id"
  has_many :identities

  enum role: %w(registered_user admin)

  def self.create_with_omniauth
    create(name: info['name'])
  end

  def self.from_fb_omniauth(auth_info)
    where(facebook_uid: auth_info[:uid], provider: auth_info[:provider]).first_or_create do |user|
      user.uid            = auth_info.uid
      user.first_name     = auth_info.info.name.split(' ')[0]
      user.last_name      = auth_info.info.name.split(' ')[1]
      user.email          = auth_info.info.email
      user.image_url      = auth_info.info.image
      user.facebook_token = auth_info.credentials.token
    end
  end

  def self.from_google_omniauth(auth_info)
    where(google_uid: auth_info[:uid], provider: auth_info[:provider]).first_or_create do |new_user|
      new_user.google_uid                   = auth_info.uid
      new_user.email                        = auth_info.email
      new_user.first_name                   = auth_info.info.first_name
      new_user.last_name                    = auth_info.info.last_name
      new_user.image_url                    = auth_info.info.image
      new_user.google_oauth_token           = auth_info.credentials.token
      new_user.google_oauth_expires_at      = auth_info.credentials.expires_at
    end
  end
end
