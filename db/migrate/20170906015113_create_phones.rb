class CreatePhones < ActiveRecord::Migration[6.1]
	def change
		create_table :phones do |t|
			t.references :ownertable, polymorphic: true, index: true
			t.string :phone_code
			t.string :phone
			t.string :responsible
			t.references :phone_type, index: true, foreign_key: true
			t.boolean :is_whatsapp

			t.timestamps
		end
	end
end
