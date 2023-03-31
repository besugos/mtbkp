class CreateCivilStates < ActiveRecord::Migration[6.1]
	def change
		create_table :civil_states do |t|
			t.string :name

			t.timestamps
		end
	end
end
