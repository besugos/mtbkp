class CreateCancelOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :cancel_orders do |t|
      t.references :order, foreign_key: true, index: true
      t.references :freight_order, foreign_key: true, index: true
      t.references :cancel_order_reason, foreign_key: true, index: true
      t.text :reason_text, :limit => 4294967

      t.timestamps
    end
  end
end
