class ChangeUidOnUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :uid, :facebook_uid
  end
end
