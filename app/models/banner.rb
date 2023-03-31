class Banner < ApplicationRecord
  after_initialize :default_values
  default_scope {includes(:banner_area).order("banner_areas.name", {position: :asc})}

  attr_accessor :seed

  belongs_to :banner_area

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  scope :by_active, lambda { |value| where("active = ?", value) if !value.nil? && !value.blank? }
  scope :by_banner_area_id, lambda { |value| where("banner_area_id = ?", value) if !value.nil? && !value.blank? }
  scope :by_title, lambda { |value| where("LOWER(title) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }

  scope :by_initial_date, lambda { |value| where("created_at >= '#{value} 00:00:00'") if !value.nil? && !value.blank? }
  scope :by_final_date, lambda { |value| where("created_at <= '#{value} 23:59:59'") if !value.nil? && !value.blank? }

  scope :by_initial_disponible_date, lambda { |value| where("disponible_date >= '#{value} 00:00:00'") if !value.nil? && !value.blank? }
  scope :by_final_disponible_date, lambda { |value| where("disponible_date <= '#{value} 23:59:59'") if !value.nil? && !value.blank? }

  scope :active, -> { where(active: true) }

  validates_presence_of :image, :image_mobile, :position, :banner_area_id, if: Proc.new { |object| object.seed != true }

  has_one_attached :image
  has_one_attached :image_mobile

  # has_attached_file :image,
  # :storage => :s3,
  # :url => ":s3_domain_url",
  # styles: { medium: "300x300#", thumb: "100x100#"},
  # :path => ":class/image/:id_partition/:style/:filename"
  # do_not_validate_attachment_file_type :image
  
  # has_attached_file :image_mobile,
  # :storage => :s3,
  # :url => ":s3_domain_url",
  # styles: { medium: "300x300#", thumb: "100x100#"},
  # :path => ":class/image_mobile/:id_partition/:style/:filename"
  # do_not_validate_attachment_file_type :image_mobile

  def self.routine_inactive_banners
    begin
      yesterday = (Date.today - 1.days)
      Banner.active.by_final_disponible_date(yesterday).update_all(active: false)
    rescue Exception => e
      Rails.logger.error e.message
    end
  end
  
  def get_text_name
    self.title.to_s
  end
  
  def get_active_text
    self.active ? Banner.human_attribute_name(:visible) : Banner.human_attribute_name(:hidden)
  end

  def get_image
    result = ""
    if !self.image.attached?
      result = "https://via.placeholder.com/1800x700//FFFFFF/?text=sem-imagem"
    else
      result = self.image.url
    end
    return result
  end

  def get_image_mobile
    result = ""
    if !self.image_mobile.attached?
      result = "https://via.placeholder.com/727x700//FFFFFF/?text=sem-imagem"
    else
      result = self.image_mobile.url
    end
    return result
  end

  def get_link
    result = ""
    if self.link.blank?
      result = "#"
    else
      result = self.link
    end
    return result
  end

  def self.get_array_banners_to_show(banners)
    result = []
    banners.each do |banner|
      object = {
        link: banner.get_link,
        image: banner.get_image,
        image_mobile: banner.get_image_mobile
      }
      result.push(object)
    end
    return result
  end

  def get_actived?
    return (self.active ? Banner.human_attribute_name(:is_active) : Banner.human_attribute_name(:inactive))
  end

  def action_active
    return (self.active ? Banner.human_attribute_name(:set_inactive) : Banner.human_attribute_name(:set_active))
  end

  private

  def default_values
    self.title ||= ""
    self.link ||= ""
    self.position ||= 0
    self.banner_area_id ||= BannerArea::PAGINA_INICIAL_ID
  end

end
