class AddPlanReferencesToDataProfessionals < ActiveRecord::Migration[6.1]
  def change
    add_reference :data_professionals, :product_plan, index: true, references: :plans
    add_reference :data_professionals, :service_plan, index: true, references: :plans
  end
end
