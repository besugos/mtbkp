class CreatePlanTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_types do |t|
      t.string :name

      t.timestamps
    end
    PlanType.create([
      {name: "Para produtos"},
      {name: "Para serviços"}
    ])

    add_reference :plans, :plan_type, foreign_key: true, index: true
  end
end
