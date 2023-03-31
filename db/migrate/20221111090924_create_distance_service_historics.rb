class CreateDistanceServiceHistorics < ActiveRecord::Migration[6.1]
  def change
    create_table :distance_service_historics do |t|
      t.string :lat_origin
      t.string :lng_origin
      t.string :lat_destination
      t.string :lng_destination
      t.text :destination_address
      t.text :origin_address
      t.text :distance_text
      t.text :duration_text
      t.decimal :distance_value, :precision => 15, :scale => 4
      t.decimal :duration_value, :precision => 15, :scale => 4

      t.timestamps
    end
  end
end
