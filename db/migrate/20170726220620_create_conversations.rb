class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.string :title
      t.integer :author_id, index: true
      t.integer :receiver_id, index: true

      t.timestamps
    end
  end
end
