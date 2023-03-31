class PaymentType < ApplicationRecord
  after_initialize :default_values
    
  def as_json(options = {})
    {
      :id => self.id,
      :name => self.name
    }
  end

  CARTAO_CREDITO_ID = 1
  BOLETO_ID = 2
  PIX_ID = 3

  private

  def default_values
  end
end
