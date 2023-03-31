class AddAttributesToPaymentTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_transactions, :pix_order_id, :text
    add_column :payment_transactions, :pix_text, :text
    add_column :payment_transactions, :pix_qrcode_link, :text
    add_column :payment_transactions, :pix_limit_payment_date, :datetime
  end
end
