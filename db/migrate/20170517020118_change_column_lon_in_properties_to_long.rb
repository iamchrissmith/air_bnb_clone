class ChangeColumnLonInPropertiesToLong < ActiveRecord::Migration[5.0]
  def change
    rename_column :properties, :lon, :long
  end
end
