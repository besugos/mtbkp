class CreateSellerCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :seller_coupons do |t|
      t.references :coupon_type, foreign_key: true, index: true
      t.references :coupon_area, foreign_key: true, index: true
      t.string :name
      t.integer :quantity
      t.date :validate_date
      t.decimal :value, :precision => 15, :scale => 2

      t.timestamps
    end
  end
end
