class CreateUserPlans < ActiveRecord::Migration[6.1]
  def change
    create_table :user_plans do |t|
      t.references :user, foreign_key: true, index: true
      t.references :plan, foreign_key: true, index: true
      t.datetime :initial_date
      t.datetime :final_date
      t.decimal :price, :precision => 15, :scale => 2
      t.date :next_payment
      t.integer :count_paid, default: 0
      t.decimal :plan_price, :precision => 15, :scale => 2
      t.boolean :use_discount_coupon, default: false

      t.timestamps
    end
  end
end
