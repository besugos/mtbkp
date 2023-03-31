class AddCompleteDataToFreightOrderOption < ActiveRecord::Migration[6.1]
  def change
    add_column :freight_order_options, :melhor_envio_complete_data, :text, :limit => 4294967295
  end
end
