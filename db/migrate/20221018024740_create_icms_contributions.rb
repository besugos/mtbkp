class CreateIcmsContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :icms_contributions do |t|
      t.string :name

      t.timestamps
    end
    IcmsContribution.create([
      {name: "Não"},
      {name: "Sim"},
      {name: "Isento"}
    ])

    add_reference :users, :icms_contribution, foreign_key: true, index: true
  end
end
