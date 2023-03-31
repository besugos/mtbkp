class ProfessionalDocumentStatus < ApplicationRecord
  after_initialize :default_values

  EM_ANALISE_ID = 1
  VALIDADO_ID = 2
  REPROVADO_ID = 3

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.name.to_s
  end

  private

  def default_values
  end

end
