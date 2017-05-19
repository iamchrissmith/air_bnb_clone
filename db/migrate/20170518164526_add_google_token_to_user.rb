class AddGoogleTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_uid, :string
    add_column :users, :google_oauth_token, :string
    add_column :users, :google_oauth_expires_at, :datetime
  end
end
