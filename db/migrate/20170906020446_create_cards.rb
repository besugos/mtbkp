class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.references :ownertable, polymorphic: true, index: true
      t.references :card_banner, foreign_key: true
      t.string :nickname
      t.string :encrypted_name
      t.string :encrypted_name_iv
      t.string :encrypted_number
      t.string :encrypted_number_iv
      t.string :encrypted_ccv_code
      t.string :encrypted_ccv_code_iv
      t.string :validate_date_month
      t.string :validate_date_year
      t.boolean :principal, default: false

      t.timestamps
    end
    
  end
end
