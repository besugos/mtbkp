class Service < ApplicationRecord
  after_initialize :default_values
  attr_accessor :images

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }
  scope :by_name, lambda { |value| where("LOWER(services.name) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }

  scope :by_initial_price, lambda { |value| where("price >= '#{value}'") if !value.nil? && !value.blank? }
  scope :by_final_price, lambda { |value| where("price <= '#{value}'") if !value.nil? && !value.blank? }

  scope :by_category_id, lambda { |value| where("services.category_id = ?", value) if !value.nil? && !value.blank? }
  scope :by_sub_category_id, lambda { |value| where("services.sub_category_id = ?", value) if !value.nil? && !value.blank? }
  scope :by_user_id, lambda { |value| where("services.user_id = ?", value) if !value.nil? && !value.blank? }

  scope :by_service_goal_id, lambda { |value| joins(:service_goals).where("service_goals.id = ?", value) if !value.nil? && !value.blank? }
  scope :by_service_ground_id, lambda { |value| joins(:service_grounds).where("service_grounds.id = ?", value) if !value.nil? && !value.blank? }
  scope :by_service_ground_type_id, lambda { |value| joins(:service_ground_types).where("service_ground_types.id = ?", value) if !value.nil? && !value.blank? }

  scope :active, -> { where(active: true) }

  scope :to_show_in_site, -> {
    where(active: true)
    .joins(:user).where(users: {seller_verified: true})
    .joins(:user).where(users: {publish_professional_profile: true})
    .joins(user: :data_professional)
    .where(users: {data_professionals: {professional_document_status_id: ProfessionalDocumentStatus::VALIDADO_ID}})
  }

  belongs_to :category
  belongs_to :sub_category
  belongs_to :user
  belongs_to :radius_service
  belongs_to :selected_address, :class_name => 'Address'

  has_and_belongs_to_many :service_goals, dependent: :destroy
  has_and_belongs_to_many :service_grounds, dependent: :destroy
  has_and_belongs_to_many :service_ground_types, dependent: :destroy

  validates_presence_of :name, :user_id, :category_id

  has_many :attachments, as: :ownertable, validate: false, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => :all_blank

  has_one :address, as: :ownertable, validate: false, dependent: :destroy
  accepts_nested_attributes_for :address
  
  has_one_attached :principal_image

  # has_attached_file :image,
  # :storage => :s3,
  # :url => ":s3_domain_url",
  # styles: { medium: "300x300#", thumb: "100x100#", select: "50x50#" },
  # :path => ":class/image/:id_partition/:style/:filename"
  # do_not_validate_attachment_file_type :image

  def get_image
    result = ""
    if !self.principal_image.attached?
      result = "https://via.placeholder.com/100x100/000000/FFFFFF/"
    else
      result = self.principal_image.url
    end
    return result
  end
  
  def get_text_name
    self.name.to_s
  end
  
  def get_name
    self.name.to_s
  end
  
  def get_price
    self.price
  end

  def get_url_image
    result = nil
    if self.principal_image.attached?
      result = self.principal_image.url
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

  def get_actived?
    return (self.active ? Service.human_attribute_name(:active) : Service.human_attribute_name(:inactive))
  end

  def self.get_array_images_to_show(service)
    result = []
    if !service.nil?
      if service.principal_image.attached?
        object = {
          link: service.get_url_image,
          image: service.get_image,
          image_mobile: service.get_image
        }
        result.push(object)
      end
      service.attachments.each do |attachment|
        object = {
          link: attachment.get_url_image,
          image: attachment.get_image,
          image_mobile: attachment.get_image
        }
        result.push(object)
      end
    end
    return result
  end

  def self.validating_lat_lng_address(service)
    begin
      address = service.get_correct_address
      if !address.nil?
        Address.getting_latitude_longitude(address)
      end
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error "-- validating_lat_lng_address --"
    end
  end

  def self.formatting_array_based_location(current_latitude, current_longitude, services_result)
    # Usuário logado atual possui latitude e longitude para busca
    services = []
    services_without_position = []
    begin
      services_result.each do |service|
        correct_address = service.get_correct_address
        if !correct_address.nil? && !correct_address.latitude.nil? && !correct_address.longitude.nil?

          old_register = DistanceServiceHistoric.by_lat_origin(current_latitude)
          .by_lng_origin(current_longitude)
          .by_lat_destination(correct_address.latitude)
          .by_lng_destination(correct_address.longitude).first

          if old_register.nil?
            google_service = Utils::Google::GoogleGetDistanceService.new(current_latitude, current_longitude, correct_address.latitude, correct_address.longitude)
            result_google = google_service.call
            if result_google[0]
              DistanceServiceHistoric.create_new_distance_service_historic(current_latitude, current_longitude, correct_address.latitude, correct_address.longitude, result_google[1])
              distance_value = result_google[1][:distance_value]
            else
              distance_value = ""
            end
          else
            distance_value = old_register.distance_value
          end

          if !distance_value.blank?
            object = {
              service: service,
              distance_value: distance_value
            }
            services.push(object)
          else
            object = {
              service: service,
              distance_value: ""
            }
            services_without_position.push(object)
          end
        else
          object = {
            service: service,
            distance_value: ""
          }
          services_without_position.push(object)
        end
      end
      services = services.sort_by{|item| item[:distance_value] if item[:distance_value].blank?}.reverse
      services.concat(services_without_position)
    rescue Exception => e
      Rails.logger.error "-- formatting_array_based_location --"
      Rails.logger.error e.message
    end
    return services
  end

  def get_correct_address
    result = nil
    if !self.selected_address.nil?
      result = self.selected_address
    else
      result = self.address
    end
    return result
  end

  def self.routine_inactive_services
    services = Service.to_show_in_site
    services.each do |service|
      user = service.user
      data_professional = service.user.data_professional
      if !user.seller_verified || data_professional.nil? || data_professional.professional_document_status_id != ProfessionalDocumentStatus::VALIDADO_ID
        service.update_columns(active: false)
      else
        last_userplan = User.getting_last_user_plan(user, PlanType::SERVICOS_NAME)
        if last_userplan
          if last_userplan.validate_date < Date.today
            service.update_columns(active: false)
          end
        else
          service.update_columns(active: false)
        end
      end
    end
  end

  private

  def default_values
    self.name ||= ""
    self.description ||= ""
  end

end
