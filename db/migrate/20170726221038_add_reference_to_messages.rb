class AddReferenceToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :conversation, index: true, foreing_key: true
  end
end
