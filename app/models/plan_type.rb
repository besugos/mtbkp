class PlanType < ApplicationRecord
  after_initialize :default_values

  PARA_PRODUTOS_ID = 1
  PARA_SERVICOS_ID = 2

  PRODUTOS_NAME = Category.human_attribute_name(:products)
  SERVICOS_NAME = Category.human_attribute_name(:services)

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.id.to_s
  end

  def self.get_name_by_id(plan_type_id)
    value = plan_type_id.to_i unless plan_type_id.nil?
    case value
    when PlanType::PARA_PRODUTOS_ID
      return PlanType::PRODUTOS_NAME
    when PlanType::PARA_SERVICOS_ID
      return PlanType::SERVICOS_NAME
    else
      return Plan.human_attribute_name(:no_information)
    end
  end

  private

  def default_values
  end

end
