class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :image_url
      t.string :email
      t.string :phone_number
      t.text :description
      t.string :hometown
      t.integer :role, default: 0
      t.boolean :active?

      t.timestamps
    end
  end
end
