class UpdatingPlansData < ActiveRecord::Migration[6.1]
  def change
    Plan.find(4).update_columns(name: "Pleno", description: "Anuncie até 5 especializações")
    Plan.find(5).update_columns(name: "Sênior", description: "Anuncie até 10 especializações")
    Plan.find(6).update_columns(name: "Master", description: "Anuncie até 15 especializações")
  end
end
