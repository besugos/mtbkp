class FreightCompany < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  validates_uniqueness_of :melhor_envio_id
  
  def get_text_name
    self.name.to_s
  end

  private

  def default_values
    self.name ||= ""
  end

end
