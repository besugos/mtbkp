class AddNewFieldsToSystemConfigurations < ActiveRecord::Migration[6.1]
  def change
    add_column :system_configurations, :footer_text, :text
    SystemConfiguration.first.update_columns(footer_text: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem distinctio recusandae voluptates nihil nostrum qui sit quo, .")
  end
end
