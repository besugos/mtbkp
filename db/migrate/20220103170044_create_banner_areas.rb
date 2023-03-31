class CreateBannerAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :banner_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
