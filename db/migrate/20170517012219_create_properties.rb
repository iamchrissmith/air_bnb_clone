class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.integer :number_of_guests
      t.integer :number_of_beds
      t.integer :number_of_rooms
      t.text :description
      t.decimal :price_per_night
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.decimal :lat
      t.decimal :lon
      t.string :image_url
      t.datetime :check_in_time
      t.datetime :check_out_time
      t.boolean :active?
      t.references :user, foreign_key: true
      t.references :room_type, foreign_key: true

      t.timestamps
    end
  end
end
