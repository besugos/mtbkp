class AddAttributesToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :order, foreign_key: true, index: true
    add_reference :messages, :admin, index: true, references: :users
  end
end
