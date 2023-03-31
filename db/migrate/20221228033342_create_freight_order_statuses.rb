class CreateFreightOrderStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :freight_order_statuses do |t|
      t.string :name

      t.timestamps
    end

    FreightOrderStatus.create([
      {name: "Aguardando envio"},
      {name: "Em rota de envio"},
      {name: "Entregue"}
    ])
    
  end
end
