class CreateDataProfessionalsSpecialties < ActiveRecord::Migration[6.1]
  def change
    create_table :data_professionals_specialties do |t|
      t.references :data_professional, foreign_key: true, index: false
      t.references :specialty, foreign_key: true, index: false
    end
  end
end
