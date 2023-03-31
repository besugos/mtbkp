class AddServiceIdToFreightOrderOption < ActiveRecord::Migration[6.1]
  def change
    add_column :freight_order_options, :melhor_envio_service_id, :integer
  end
end
