class AddressArea < ApplicationRecord
  after_initialize :default_values

  GENERAL_ID = 1
  ENDERECO_ENTREGA_ID = 2
  ENDERECO_SAIDA_ID = 3

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.id.to_s
  end

  private

  def default_values
  end

end
