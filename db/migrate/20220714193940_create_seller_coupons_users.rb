class CreateSellerCouponsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :seller_coupons_users do |t|
      t.references :seller_coupon, foreign_key: true, index: false
      t.references :user, foreign_key: true, index: false
    end
  end
end
