class AddQuantityMonthsToUseCouponSeller < ActiveRecord::Migration[6.1]
  def change
    add_column :seller_coupons, :quantity_months, :integer, default: 1
  end
end
