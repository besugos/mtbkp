class AddSystemConfigurationsAttributesToMelhorEnvio < ActiveRecord::Migration[6.1]
  def change
    add_column :system_configurations, :melhor_envio_access_token, :text
    add_column :system_configurations, :melhor_envio_refresh_token, :text
    add_column :system_configurations, :melhor_envio_expires_date, :date
  end
end
