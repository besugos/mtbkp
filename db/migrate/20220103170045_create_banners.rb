class CreateBanners < ActiveRecord::Migration[6.1]
  def change
    create_table :banners do |t|
      t.references :banner_area, foreign_key: true, index: true
      t.string :link
      t.string :title
      t.integer :position
      t.boolean :active, default: true
      t.date :disponible_date

      t.timestamps
    end
  end
end
