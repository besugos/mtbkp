class CreateOrders < ActiveRecord::Migration[6.1]
	def change
		create_table :orders do |t|
			t.references :order_status, foreign_key: true
			t.references :user, foreign_key: true
			t.references :payment_type, foreign_key: true
			t.integer :installments, default: 1
			t.decimal :price, :precision => 15, :scale => 2, default: 0
			t.decimal :total_value, :precision => 15, :scale => 2, default: 0
			t.decimal :total_freight_value, :precision => 15, :scale => 2, default: 0

			t.timestamps
		end
	end
end
