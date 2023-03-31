class AddCellphoneContactsToSystemConfigurations < ActiveRecord::Migration[6.1]
  def change
    add_column :system_configurations, :client_cellphone, :string, default: "(31) 99999-9999"
    add_column :system_configurations, :professional_cellphone, :string, default: "(31) 99999-9999"
  end
end
