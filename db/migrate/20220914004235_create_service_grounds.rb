class CreateServiceGrounds < ActiveRecord::Migration[6.1]
  def change
    create_table :service_grounds do |t|
      t.string :name

      t.timestamps
    end
    
    create_join_table :services, :service_grounds

    ServiceGround.create([
      {name: "Rural"},
      {name: "Urbano"},
    ])
  end
end
