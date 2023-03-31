class CreateFreightOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :freight_orders do |t|
      t.references :order, foreign_key: true, index: true
      t.references :seller, index: true, references: :users

      t.timestamps
    end
  end
end
