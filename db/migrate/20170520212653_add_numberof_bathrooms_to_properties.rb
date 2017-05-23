class AddNumberofBathroomsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :number_of_bathrooms, :integer
  end
end
