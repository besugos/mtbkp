class PlanService < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  belongs_to :plan
  
  def get_text_name
    self.title.to_s
  end

  private

  def default_values
    self.title ||= ""
    self.show ||= true if self.show.nil?
  end

end
