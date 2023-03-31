class ProfessionalAvaliation < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  scope :by_professional_id, lambda { |value| where("professional_id = ?", value) if !value.nil? && !value.blank? }
  scope :by_client_id, lambda { |value| where("client_id = ?", value) if !value.nil? && !value.blank? }

  belongs_to :professional, class_name: "User"
  belongs_to :client, class_name: "User"
  belongs_to :order

  validates_presence_of :order_id, :professional_id, :client_id
  
  def get_text_name
    self.id.to_s
  end

  private

  def default_values
    self.deadline_avaliation ||= 0
    self.quality_avaliation ||= 0
    self.problems_solution_avaliation ||= 0
  end

end
