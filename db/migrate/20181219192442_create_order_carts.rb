class CreateOrderCarts < ActiveRecord::Migration[6.1]
	def change
		create_table :order_carts do |t|
			t.references :order, foreign_key: true
			t.references :ownertable, polymorphic: true, index: true
			t.integer :quantity
			t.decimal :unity_price, :precision => 15, :scale => 2, default: 0
			t.decimal :total_value, :precision => 15, :scale => 2, default: 0

			t.decimal :freight_value, :precision => 15, :scale => 2, default: 0
			t.decimal :freight_value_total, :precision => 15, :scale => 2, default: 0

			t.timestamps
		end
	end
end
