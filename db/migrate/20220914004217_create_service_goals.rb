class CreateServiceGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :service_goals do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :services, :service_goals

    ServiceGoal.create([
      {name: "Aprovação de Obra em Prefeitura"},
      {name: "Definição de Divisas"},
      {name: "Demandas Judiciais"},
      {name: "Desmembramento/Desdobro/Usucapião"},
      {name: "Imagem Georreferenciada da área"},
      {name: "Obtenção de MDT (Modelo Digital de Terreno)"},
      {name: "Projeto de Engenharia/Arquiterura"},
      {name: "Regularização (Cartório, Prefeitura, Incra e/ou outros orgãos)"},
      {name: "Outros"},
    ])
  end
end
