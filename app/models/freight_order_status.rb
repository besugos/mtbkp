class FreightOrderStatus < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  AGUARDANDO_ENVIO_ID = 1
  EM_ROTA_DE_ENVIO_ID = 2
  ENTREGUE_ID = 3
  ENVIO_PEDIDO_CANCELADO_ID = 4
  
  def get_text_name
    self.id.to_s
  end

  private

  def default_values
  end

end
