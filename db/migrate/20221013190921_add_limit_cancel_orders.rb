class AddLimitCancelOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :freight_orders, :limit_cancel_order, :datetime
  end
end
