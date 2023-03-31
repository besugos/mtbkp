class ChangeColumnPaymentMessage < ActiveRecord::Migration[6.1]
  def change
    change_column(:payment_transactions, :payment_message, :text, :limit => 42949672)
  end
end
