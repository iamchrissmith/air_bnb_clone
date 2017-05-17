class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.decimal :total_price
      t.datetime :start_date
      t.datetime :end_date
      t.integer :number_of_guests
      t.references :property, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
