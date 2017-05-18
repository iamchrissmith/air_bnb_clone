class ChangeCheckInCheckOutInProperties < ActiveRecord::Migration[5.0]
  def change
    change_column :properties, :check_in_time, :time
    change_column :properties, :check_out_time, :time
  end
end
