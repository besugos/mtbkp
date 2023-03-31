class CreateProductConditions < ActiveRecord::Migration[6.1]
  def change
    create_table :product_conditions do |t|
      t.string :name

      t.timestamps
    end
  end
end
