class CreateBanks < ActiveRecord::Migration[6.1]
	def change
		create_table :banks do |t|
			t.string :number
			t.string :name

			t.timestamps
		end
	end
end
