class AddFreightOrderStatus < ActiveRecord::Migration[6.1]
  def change
    FreightOrderStatus.create(name: "Envio/pedido cancelado.")
  end
end
