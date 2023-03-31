class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.references :category, foreign_key: true, index: true
      t.references :sub_category, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.references :radius_service, foreign_key: true, index: true
      
      t.string :name
      t.decimal :price, :precision => 15, :scale => 2
      t.text :tags
      t.boolean :active
      t.text :description

      t.decimal :avaliation_value, default: 0, :precision => 4, :scale => 2

      t.references :selected_address, index: true, references: :addresses

      t.timestamps
    end
  end
end