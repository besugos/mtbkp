class AddReferencesDiscountToOrderCarts < ActiveRecord::Migration[6.1]
  def change
    add_reference :order_carts, :seller_coupon, foreign_key: true, index: true
    add_column :order_carts, :discount_coupon_value, :decimal, :precision => 15, :scale => 2
    add_column :order_carts, :discount_coupon_text, :string
  end
end
