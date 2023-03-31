class CreateDataBankTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :data_bank_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
