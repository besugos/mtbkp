class AddZipcodeToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :zipcode_delivery, :string
  end
end
