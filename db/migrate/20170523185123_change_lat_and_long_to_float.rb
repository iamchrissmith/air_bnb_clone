class ChangeLatAndLongToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :properties, :lat, :float
    change_column :properties, :long, :float
  end
end
