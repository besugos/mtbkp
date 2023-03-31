class CreateDataBanks < ActiveRecord::Migration[6.1]
	def change
		create_table :data_banks do |t|
			t.references :ownertable, polymorphic: true, index: true
			t.references :bank, index: true, foreign_key: true
			t.references :data_bank_type, index: true, foreign_key: true
			t.string :bank_number
			t.string :agency
			t.string :account
			t.string :operation
			t.string :assignor
			t.string :cpf_cnpj
			t.string :pix

			t.timestamps
		end

	end
end
