class ChangeReservedToReservedInPropertyAvailabilities < ActiveRecord::Migration[5.0]
  def change
    rename_column :property_availabilities, :reserved?, :reserved
  end
end
