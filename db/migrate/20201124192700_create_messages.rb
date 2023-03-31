class CreateMessages < ActiveRecord::Migration[6.1]
	def change
		create_table :messages do |t|
			t.references :sender, index: true, references: :users
			t.references :receiver, index: true, references: :users
			t.text :content

			t.timestamps
		end
	end
end
