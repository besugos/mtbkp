class OrderTypeRecurrent < ApplicationRecord
  after_initialize :default_values

  RECURRENT_ID = 1
  UNITY_ID = 2
  
  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.id.to_s
  end

  private

  def default_values
  end

end
