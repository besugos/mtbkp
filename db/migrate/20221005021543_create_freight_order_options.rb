class CreateFreightOrderOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :freight_order_options do |t|
      t.references :freight_order, foreign_key: true, index: true
      t.string :name
      t.decimal :price
      t.integer :delivery_time
      t.references :freight_company, foreign_key: true, index: true
      t.boolean :selected, default: false

      t.timestamps
    end
  end
end
