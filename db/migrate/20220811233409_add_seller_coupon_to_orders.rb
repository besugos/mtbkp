class AddSellerCouponToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :seller_coupon, foreign_key: true, index: true
    add_column :orders, :discount_by_seller_coupon, :decimal, :precision => 15, :scale => 2
  end
end
