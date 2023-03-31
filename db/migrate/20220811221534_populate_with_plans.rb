class PopulateWithPlans < ActiveRecord::Migration[6.1]
  def change
    Plan.create(
      plan_type_id: PlanType::PARA_PRODUTOS_ID,
      name: "Bronze",
      price: "R$ 30,00",
      limit_products: 5,
      description: "Consegue anunciar até 5 produtos",
      plan_periodicity_id: PlanPeriodicity::MENSAL_ID
      )
    Plan.create(
      plan_type_id: PlanType::PARA_PRODUTOS_ID,
      name: "Prata",
      price: "R$ 60,00",
      limit_products: 12,
      description: "Consegue anunciar até 12 produtos",
      plan_periodicity_id: PlanPeriodicity::MENSAL_ID
      )
    Plan.create(
      plan_type_id: PlanType::PARA_PRODUTOS_ID,
      name: "Ouro",
      price: "R$ 90,00",
      limit_products: 30,
      description: "Consegue anunciar até 30 produtos",
      plan_periodicity_id: PlanPeriodicity::MENSAL_ID
      )

    Plan.create(
      plan_type_id: PlanType::PARA_SERVICOS_ID,
      name: "Junior ou Iniciante",
      price: "R$ 29,90",
      limit_service_categories: 5,
      description: "Consegue anunciar 5 serviços associado a uma categoria ou mais de um serviço com outras categorias",
      plan_periodicity_id: PlanPeriodicity::MENSAL_ID
      )
    Plan.create(
      plan_type_id: PlanType::PARA_SERVICOS_ID,
      name: "Pleno ou Experiente",
      price: "R$ 49,90",
      limit_service_categories: 10,
      description: "Consegue anunciar 10 serviços associado a uma categoria ou mais de um serviço com outras categorias",
      plan_periodicity_id: PlanPeriodicity::MENSAL_ID
      )
    Plan.create(
      plan_type_id: PlanType::PARA_SERVICOS_ID,
      name: "Sênior ou Profissional",
      price: "R$ 69,90",
      limit_service_categories: 15,
      description: "Consegue anunciar 15 serviços associado a uma categoria ou mais de um serviço com outras categorias",
      plan_periodicity_id: PlanPeriodicity::MENSAL_ID
      )
  end
end
