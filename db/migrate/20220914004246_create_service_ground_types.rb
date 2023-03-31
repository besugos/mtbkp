class CreateServiceGroundTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :service_ground_types do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :services, :service_ground_types
    
    ServiceGroundType.create([
      {name: "Acidentado"},
      {name: "Alagado"},
      {name: "Com vegetação"},
      {name: "Mata Densa"},
      {name: "Plano"},
      {name: "Outros"},
    ])
    
  end
end
