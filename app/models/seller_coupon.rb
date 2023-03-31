class SellerCoupon < ApplicationRecord
  before_destroy :remove_vinculed_data
  after_initialize :default_values
  before_validation :insert_skip_validate_user

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  scope :by_name, lambda { |value| where("LOWER(seller_coupons.name) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }
  
  scope :by_exactly_name, lambda { |value| where("LOWER(seller_coupons.name) = ?", "#{value.downcase}") if !value.nil? && !value.blank? }

  scope :by_coupon_type_id, lambda { |value| where("seller_coupons.coupon_type_id = ?", value) if !value.nil? && !value.blank? }
  
  scope :by_coupon_area_id, lambda { |value| where("seller_coupons.coupon_area_id = ?", value) if !value.nil? && !value.blank? }

  scope :by_initial_quantity, lambda { |value| where("seller_coupons.quantity >= '#{value}'") if !value.nil? && !value.blank? }
  scope :by_final_quantity, lambda { |value| where("seller_coupons.quantity <= '#{value}'") if !value.nil? && !value.blank? }

  scope :by_initial_validate_date, lambda { |value| where("seller_coupons.validate_date >= '#{value} 00:00:00'") if !value.nil? && !value.blank? }
  scope :by_final_validate_date, lambda { |value| where("seller_coupons.validate_date <= '#{value} 23:59:59'") if !value.nil? && !value.blank? }

  scope :active, -> { 
    by_initial_validate_date(Date.today)
  }

  belongs_to :coupon_type
  belongs_to :coupon_area

  has_and_belongs_to_many :users, validate: false, dependent: :destroy

  has_many :order_carts, validate: false

  validates_presence_of :name, :quantity, :coupon_type_id, :coupon_area_id
  
  def get_text_name
    self.name.to_s
  end

  def get_correct_value_discount(initial_value)
    result = 0
    if !initial_value.nil? && initial_value > 0
      if self.coupon_type_id == CouponType::PERCENTUAL_ID
        result = initial_value * ((self.value)/100).to_f
      elsif self.coupon_type_id == CouponType::FINANCEIRO_ID
        if initial_value < self.value
          result = initial_value
        else
          result = self.value
        end
      end
    end
    return result
  end

  private

  def default_values
    self.name ||= ""
    self.coupon_type_id ||= CouponType::PERCENTUAL_ID
  end

  def remove_vinculed_data
    self.order_carts.update_all(seller_coupon_id: nil)
  end

  def insert_skip_validate_user
    self.users.each do |user|
      Rails.logger.info "teste"
      user.skip_validate_password = true
    end
  end

end
