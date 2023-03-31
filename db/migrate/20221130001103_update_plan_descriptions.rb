class UpdatePlanDescriptions < ActiveRecord::Migration[6.1]
  def change
    Plan.find(4).update_columns(description: "Anuncie até 5 serviços")
    Plan.find(5).update_columns(description: "Anuncie até 10 serviços")
    Plan.find(6).update_columns(description: "Anuncie até 15 serviços")
  end
end
