class AddBudgetToServices < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :activate_budget, :boolean, default: false
    add_column :services, :budget_whatsapp, :string
  end
end
