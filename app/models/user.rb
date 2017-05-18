class User < ApplicationRecord
  has_many :reservations, foreign_key: "renter_id"
  has_many :properties, foreign_key: "owner_id"

  enum role: %w(registered_user admin)

  def self.from_fb_omniauth(auth_info)
    where(uid: auth_info[:uid]).first_or_create do |user|
      user.uid              = auth_info.uid
      user.first_name       = auth_info.info.name.split(' ')[0]
      user.last_name        = auth_info.info.name.split(' ')[1]
      user.email            = auth_info.info.email
      user.image_url        = auth_info.info.image
      user.facebook_token   = auth_info.credentials.token
    end
  end
end
