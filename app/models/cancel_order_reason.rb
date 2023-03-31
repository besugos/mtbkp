class CancelOrderReason < ApplicationRecord
  after_initialize :default_values

  NAO_GOSTEI_ID = 1
  PRODUTO_VEIO_COM_DEFEITO_ID = 2
  OUTRO_ID = 3

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.id.to_s
  end

  private

  def default_values
  end

end
