class CreatePropertyReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :property_reviews do |t|
      t.references :property, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :rating
      t.string :body
      t.references :reservation, foreign_key: true

      t.timestamps
    end
  end
end
