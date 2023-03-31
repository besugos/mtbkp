class AddAttributesToFreightOrderOptions < ActiveRecord::Migration[6.1]
  def change
    add_column :freight_order_options, :tracking_code, :text
    add_reference :freight_order_options, :freight_order_status, foreign_key: true, index: true
  end
end
