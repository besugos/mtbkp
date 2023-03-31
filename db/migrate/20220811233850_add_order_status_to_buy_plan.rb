class AddOrderStatusToBuyPlan < ActiveRecord::Migration[6.1]
  def change
    OrderStatus.create(name: "Em aberto (compra de planos)")
  end
end
