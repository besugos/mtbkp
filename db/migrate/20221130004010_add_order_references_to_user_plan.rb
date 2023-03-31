class AddOrderReferencesToUserPlan < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_plans, :order, foreign_key: true, index: true
  end
end
