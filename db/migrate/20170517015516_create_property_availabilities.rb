class CreatePropertyAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :property_availabilities do |t|
      t.date :date
      t.boolean :reserved?
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
