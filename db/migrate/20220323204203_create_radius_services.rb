class CreateRadiusServices < ActiveRecord::Migration[6.1]
  def change
    create_table :radius_services do |t|
      t.string :name

      t.timestamps
    end
  end
end
