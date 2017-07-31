class CreateUserReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :user_reviews do |t|
      t.references :user, foreign_key: true
      t.integer :rating
      t.string :body
      t.references :reservation, foreign_key: true

      t.timestamps
    end
    add_reference :user_reviews, :renter, references: :users
  end
end
