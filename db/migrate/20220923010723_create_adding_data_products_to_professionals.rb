class CreateAddingDataProductsToProfessionals < ActiveRecord::Migration[6.1]
  def change
    add_column :data_professionals, :quantity_products_to_register, :integer, default: 0
    add_column :data_professionals, :quantity_products_active, :integer, default: 0
    add_column :data_professionals, :quantity_products_left, :integer, default: 0

    add_column :data_professionals, :quantity_services_to_register, :integer, default: 0
    add_column :data_professionals, :quantity_services_active, :integer, default: 0
    add_column :data_professionals, :quantity_services_left, :integer, default: 0
  end
end
