class CreateRooms < ActiveRecord::Migration[6.1]
	def change
		create_table :rooms do |t|
			t.references :first_participant, index: true, references: :users
			t.references :second_participant, index: true, references: :users
			t.timestamps
		end
	end
end
