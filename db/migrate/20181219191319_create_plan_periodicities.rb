class CreatePlanPeriodicities < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_periodicities do |t|
      t.string :name
      t.integer :months
      t.integer :days

      t.timestamps
    end

    PlanPeriodicity.create([
      {name: "Mensal", months: "1", days: "30"},
      {name: "Bimestral", months: "2", days: "60"},
      {name: "Trimestral", months: "3", days: "90"},
      {name: "Semestral", months: "6", days: "180"},
      {name: "Anual", months: "12", days: "365"}
    ])
  end
end
