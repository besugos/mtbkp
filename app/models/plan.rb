class Plan < ApplicationRecord
  after_initialize :default_values

  validates_presence_of :name

  belongs_to :category
  belongs_to :sub_category
  belongs_to :plan_periodicity
  belongs_to :plan_type

  has_many :plan_services, validate: false, dependent: :destroy
  accepts_nested_attributes_for :plan_services, :reject_if => proc { |attrs| attrs[:title].blank? }
  
  has_one_attached :image
  has_one_attached :banner_image

  # has_attached_file :image,
  # :storage => :s3,
  # :url => ":s3_domain_url",
  # styles: { medium: "300x300#", thumb: "100x100#" },
  # :path => ":class/image/:id_partition/:style/:filename"
  # do_not_validate_attachment_file_type :image

  # has_attached_file :banner_image,
  # :storage => :s3,
  # :url => ":s3_domain_url",
  # styles: { medium: "300x300#", thumb: "100x100#" },
  # :path => ":class/banner_image/:id_partition/:style/:filename"
  # do_not_validate_attachment_file_type :banner_image

  scope :active, -> { where(active: true) }

  scope :by_active, lambda { |value| where(active: value) if !value.nil? && !value.blank? }

  scope :by_name, lambda { |value| where("LOWER(plans.name) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }

  scope :by_initial_price, lambda { |value| where("price >= '#{value}'") if !value.nil? && !value.blank? }
  scope :by_final_price, lambda { |value| where("price <= '#{value}'") if !value.nil? && !value.blank? }

  scope :by_initial_date, lambda { |value| where("created_at >= '#{value} 00:00:00'") if !value.nil? && !value.blank? }
  scope :by_final_date, lambda { |value| where("created_at <= '#{value} 23:59:59'") if !value.nil? && !value.blank? }

  scope :by_plan_type_id, lambda { |value| where("plans.plan_type_id = ?", value) if !value.nil? && !value.blank? }
  scope :by_plan_periodicity_id, lambda { |value| where("plans.plan_periodicity_id = ?", value) if !value.nil? && !value.blank? }
  scope :by_category_id, lambda { |value| where("plans.category_id = ?", value) if !value.nil? && !value.blank? }
  scope :by_sub_category_id, lambda { |value| where("plans.sub_category_id = ?", value) if !value.nil? && !value.blank? }

  def get_text_name
    return self.name
  end
  
  def get_image
    result = ""
    if !self.image.attached?
      result = "https://via.placeholder.com/300x300/000000/FFFFFF/?text=plano"
    else
      result = self.image.variant(resize_to_limit: [300, 300]).processed.url
    end
    return result
  end

  def price=(new_price)
    new_price = new_price.to_s
    if new_price.include?('.')
      new_price = new_price.gsub!('.', '')
    end
    if new_price.include?('R$')
      new_price = new_price.gsub!('R$', '')
    end
    if new_price.include?('%')
      new_price = new_price.gsub!('%', '')
    end
    if new_price.include?(',')
      new_price = new_price.gsub!(',', '.')
    end
    new_price = new_price.to_f
    self[:price] = new_price
  end

  def old_price=(new_old_price)
    new_old_price = new_old_price.to_s
    if new_old_price.include?('.')
      new_old_price = new_old_price.gsub!('.', '')
    end
    if new_old_price.include?('R$')
      new_old_price = new_old_price.gsub!('R$', '')
    end
    if new_old_price.include?('%')
      new_old_price = new_old_price.gsub!('%', '')
    end
    if new_old_price.include?(',')
      new_old_price = new_old_price.gsub!(',', '.')
    end
    new_old_price = new_old_price.to_f
    self[:old_price] = new_old_price
  end

  def get_price
    self.price
  end

  def get_url_image
    result = nil
    if !self.image.blank?
      result = self.image.url
    end
    return result
  end

  def get_title
    return self.name
  end

  def get_name
    return self.name
  end

  def text_blocked
    if !self.active
      return Plan.human_attribute_name(:set_active)
    end
    return Plan.human_attribute_name(:set_inactive)
  end

  def get_is_blocked?
    return (self.active ? Plan.human_attribute_name(:inactive) : Plan.human_attribute_name(:actived))
  end

  private

  def default_values
    self.old_price ||= 0
    self.price ||= 0
    self.description ||= ""
    self.active ||= true if self.active.nil?
  end
end
