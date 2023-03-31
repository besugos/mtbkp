class CreateProducts < ActiveRecord::Migration[6.1]
	def change
		create_table :products do |t|
			t.references :category, foreign_key: true, index: true
			t.references :sub_category, foreign_key: true, index: true
			t.references :user, foreign_key: true, index: true

			t.references :product_condition, foreign_key: true, index: true

			t.string :title
			t.decimal :price, :precision => 15, :scale => 2
			t.text :description

			t.integer :quantity_stock
			t.decimal :promotional_price, :precision => 15, :scale => 2
			
			t.decimal :avaliation_value, default: 0, :precision => 4, :scale => 2

			t.string :width 
			t.string :height 
			t.string :depth 
			t.string :weight

			t.references :selected_address, index: true, references: :addresses

			t.timestamps
		end
	end
end
