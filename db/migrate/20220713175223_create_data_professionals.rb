class CreateDataProfessionals < ActiveRecord::Migration[6.1]
  def change
    create_table :data_professionals do |t|
      t.references :user, foreign_key: true, index: true
      t.references :professional_document_status, foreign_key: true, index: true
      t.string :email
      t.string :phone
      t.string :site
      t.string :profession
      t.string :register_type
      t.string :register_number
      t.text :repprovation_reason

      t.timestamps
    end
  end
end