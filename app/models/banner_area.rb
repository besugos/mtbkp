class BannerArea < ApplicationRecord
  after_initialize :default_values
  default_scope {order("banner_areas.name")}
  
  PAGINA_INICIAL_ID = 1
  PRODUTOS_ID = 2
  SERVICOS_ID = 3
  PEDIDOS_ID = 4

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.name.to_s
  end

  private

  def default_values
  end

end
