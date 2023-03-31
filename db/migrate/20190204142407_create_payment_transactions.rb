class CreatePaymentTransactions < ActiveRecord::Migration[6.1]
	def change
		create_table :payment_transactions do |t|
			t.references :ownertable, polymorphic: true, index: true
			t.decimal :value, :precision => 15, :scale => 2
			t.string :payment_message
			t.string :payment_code
			t.string :invoice_id
			t.string :invoice_barcode
			t.string :invoice_barcode_formatted
			t.date :due_date
			t.string :pdf_link
			t.string :png_link
			t.references :payment_status, foreign_key: true

			t.timestamps
		end
		
	end
end
