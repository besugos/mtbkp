class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.references :category, foreign_key: true, index: true
      t.references :sub_category, foreign_key: true, index: true
      t.references :plan_periodicity, foreign_key: true, index: true
      
      t.string :name
      t.decimal :price, :precision => 15, :scale => 2
      t.decimal :old_price, :precision => 15, :scale => 2
      t.boolean :active, default: true

      t.text :description, :limit => 42949672
      t.text :observations, :limit => 42949672

      t.timestamps
    end
  end
end
