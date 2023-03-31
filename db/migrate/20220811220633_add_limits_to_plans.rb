class AddLimitsToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :limit_products, :integer, default: 0
    add_column :plans, :limit_service_categories, :integer, default: 0
  end
end
