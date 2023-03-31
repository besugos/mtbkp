class CreatePaymentStatuses < ActiveRecord::Migration[6.1]
	def change
		create_table :payment_statuses do |t|
			t.string :name
			
			t.timestamps
		end
	end
end
