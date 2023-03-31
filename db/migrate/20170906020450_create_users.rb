class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :access_user
      t.string :password_digest
      t.string :recovery_token
      t.boolean :is_blocked, default: false
      t.references :profile, index: true, foreign_key: true
      t.string :phone
      t.string :cpf
      t.string :rg
      t.date :birthday

      t.references :person_type, index: true, foreign_key: true
      t.references :sex, index: true, foreign_key: true
      t.references :payment_type, index: true, foreign_key: true
      t.references :civil_state, index: true, foreign_key: true

      t.string :social_name
      t.string :fantasy_name
      t.string :cnpj

      t.boolean :accept_therm, default: false

      t.string :cellphone
      t.string :profession

      t.string :provider, limit: 50, null: false, default: ""
      t.string :uid, limit: 500, null: false, default: ""

      t.boolean :seller_verified, default: false
      t.boolean :publish_professional_profile, default: false

      t.text :description, :limit => 4294967295
      t.text :work_experience, :limit => 4294967295

      t.decimal :deadline_avaliation, :precision => 15, :scale => 2
      t.decimal :quality_avaliation, :precision => 15, :scale => 2
      t.decimal :problems_solution_avaliation, :precision => 15, :scale => 2

      t.timestamps
    end
  end
end
