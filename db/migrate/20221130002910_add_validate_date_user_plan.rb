class AddValidateDateUserPlan < ActiveRecord::Migration[6.1]
  def change
    add_column :user_plans, :validate_date, :date
  end
end
