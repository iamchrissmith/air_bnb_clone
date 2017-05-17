class ChangeForeignKeyForProperties < ActiveRecord::Migration[5.0]
  def change
    rename_column :properties, :user_id, :owner_id
  end
end
