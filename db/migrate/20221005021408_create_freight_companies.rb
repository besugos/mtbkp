class CreateFreightCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :freight_companies do |t|
      t.string :name
      t.integer :melhor_envio_id
      t.text :picture_url

      t.timestamps
    end
  end
end
