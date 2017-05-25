class ChangeReservedInPropertyAvailabilities < ActiveRecord::Migration[5.0]
  def change
    change_column :property_availabilities, :reserved?, :boolean, :default => false
  end
end
