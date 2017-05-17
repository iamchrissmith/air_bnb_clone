class Change < ActiveRecord::Migration[5.0]
  def change
    change_column :room_types, :name, 'integer USING CAST(name AS integer)'
  end
end
