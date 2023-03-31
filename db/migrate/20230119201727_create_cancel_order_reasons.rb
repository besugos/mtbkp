class CreateCancelOrderReasons < ActiveRecord::Migration[6.1]
  def change
    create_table :cancel_order_reasons do |t|
      t.string :name

      t.timestamps
    end
    CancelOrderReason.create([
      {name: "Não gostei"},
      {name: "Produto veio com defeito"},
      {name: "Outro"},
    ])
  end
end
