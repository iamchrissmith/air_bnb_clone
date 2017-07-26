class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.string :title
      t.references :user, index: true, foreing_key: true

      t.timestamps
    end
  end
end
