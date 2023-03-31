class AddOtherServiceCategory < ActiveRecord::Migration[6.1]
  def change
    Category.create([
      {name: "Outros", category_type_id: CategoryType::SERVICOS_ID},
    ])
  end
end
