class CreatePlanServices < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_services do |t|
      t.references :plan, foreign_key: true
      t.text :title
      t.boolean :show, default: true

      t.timestamps
    end
  end
end
