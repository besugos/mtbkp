class CreateProfessionalAvaliations < ActiveRecord::Migration[6.1]
  def change
    create_table :professional_avaliations do |t|
      t.references :professional, index: true, references: :users
      t.references :client, index: true, references: :users
      t.references :order, index: true, foreign_key: true
      t.integer :deadline_avaliation, default: 0
      t.integer :quality_avaliation, default: 0
      t.integer :problems_solution_avaliation, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
