class ChangeActiveInProperties < ActiveRecord::Migration[5.0]
  def change
    change_column :properties, :active?,'integer USING CAST(name AS integer)'
    rename_column :properties, :active?, :status
  end

end
