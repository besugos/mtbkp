class FreightOrder < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  belongs_to :order
  belongs_to :seller, :class_name => 'User'

  has_many :freight_order_options, dependent: :destroy
  accepts_nested_attributes_for :freight_order_options

  has_one :cancel_order, dependent: :destroy
  accepts_nested_attributes_for :cancel_order

  def get_text_name
    self.id.to_s
  end

  private

  def default_values
  end

end
