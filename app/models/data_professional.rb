class DataProfessional < ApplicationRecord
  after_initialize :default_values

  attr_accessor :files

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  belongs_to :user
  belongs_to :professional_document_status

  belongs_to :product_plan, :class_name => 'Plan'
  belongs_to :service_plan, :class_name => 'Plan'

  has_and_belongs_to_many :specialties, dependent: :destroy

  validates_presence_of :email, :phone, :profession, :register_type, :register_number,
  :professional_document_status_id, if: Proc.new { |object| object.user.publish_professional_profile }

  has_many :attachments, as: :ownertable, validate: false, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => :all_blank

  has_one :address, as: :ownertable, validate: false, dependent: :destroy
  accepts_nested_attributes_for :address, :reject_if => :all_blank

  validates_presence_of :repprovation_reason, if: Proc.new { |object| object.user.publish_professional_profile && object.professional_document_status_id == ProfessionalDocumentStatus::REPROVADO_ID }
  
  def get_text_name
    self.id.to_s
  end

  def self.update_active_products(current_user)
    begin
      data_professional = current_user.data_professional
      if !data_professional.nil?
        quantity_products_active = Product.by_user_id(current_user.id).length
        quantity_products_left = data_professional.quantity_products_to_register - quantity_products_active
        data_professional.update_columns(quantity_products_active: quantity_products_active, quantity_products_left: quantity_products_left)
      end
    rescue Exception => e
      Rails.logger.error "-- update_active_products --"
      Rails.logger.error e.message
    end
  end

  def self.update_active_services(current_user)
    begin
      data_professional = current_user.data_professional
      if !data_professional.nil?
        quantity_services_active = Service.by_user_id(current_user.id).length
        quantity_services_left = data_professional.quantity_services_to_register - quantity_services_active
        data_professional.update_columns(quantity_services_active: quantity_services_active, quantity_services_left: quantity_services_left)
      end
    rescue Exception => e
      Rails.logger.error "-- update_active_services --"
      Rails.logger.error e.message
    end
  end

  private

  def default_values
    self.professional_document_status_id ||= ProfessionalDocumentStatus::EM_ANALISE_ID
    self.email ||= ""
    self.phone ||= ""
    self.site ||= ""
    self.profession ||= ""
    self.register_type ||= ""
    self.register_number ||= ""
  end

end
