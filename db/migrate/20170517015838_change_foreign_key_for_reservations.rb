class ChangeForeignKeyForReservations < ActiveRecord::Migration[5.0]
  def change
    rename_column :reservations, :user_id, :renter_id
  end
end
