class CreateEmails < ActiveRecord::Migration[6.1]
	def change
		create_table :emails do |t|
			t.references :ownertable, polymorphic: true, index: true
			t.string :email
			t.references :email_type, index: true, foreign_key: true

			t.timestamps
		end
		
	end
end
