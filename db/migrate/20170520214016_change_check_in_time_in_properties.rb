class ChangeCheckInTimeInProperties < ActiveRecord::Migration[5.0]
  def change
    change_column :properties, :check_in_time, :string
    change_column :properties, :check_out_time, :string
  end
end
