class CreateProfessionalDocumentStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :professional_document_statuses do |t|
      t.string :name

      t.timestamps
    end
    ProfessionalDocumentStatus.create([
      {name: "Aguardando análise pelo MT"},
      {name: "Validado pelo MT"},
      {name: "Reprovado pelo MT"},
    ])
  end
end
