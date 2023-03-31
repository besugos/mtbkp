class AddQuantityMonthsToUserPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :user_plans, :quantity_months_discount, :integer, default: 1
  end
end
