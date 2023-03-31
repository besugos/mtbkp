class CreateOrderTypeRecurrents < ActiveRecord::Migration[6.1]
  def change
    create_table :order_type_recurrents do |t|
      t.string :name

      t.timestamps
    end
    OrderTypeRecurrent.create([
      {name: "Compra recorrente"},
      {name: "Compra unitária"}
    ])
    add_reference :orders, :order_type_recurrent, foreign_key: true, index: true
  end
end
