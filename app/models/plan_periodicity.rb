class PlanPeriodicity < ApplicationRecord
  after_initialize :default_values

  MENSAL_ID = 1
  BIMESTRAL_ID = 2
  TRIMESTRAL_ID = 3
  SEMESTRAL_ID = 4
  ANUAL_ID = 5

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.id.to_s
  end

  private

  def default_values
  end

end
