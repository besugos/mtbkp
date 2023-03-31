class Specialty < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  scope :by_name, lambda { |value| where("LOWER(specialties.name) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }

  validates_presence_of :name

  has_and_belongs_to_many :data_professionals, dependent: :destroy
  
  def get_text_name
    self.name.to_s
  end

  private

  def default_values
    self.name ||= ""
  end

end
