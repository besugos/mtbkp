class CouponArea < ApplicationRecord
  after_initialize :default_values

  CUPOM_VENDEDOR_ID = 1
  CUPOM_DESCONTO_ID = 2

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.name.to_s
  end

  private

  def default_values
  end

end
