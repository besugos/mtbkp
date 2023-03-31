class UsersGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    User.user
    .includes(:profile)
    .includes(:data_professional)
    .includes(data_professional: :professional_document_status)
    .includes(data_professional: :product_plan)
    .includes(data_professional: :service_plan)
  end

  attr_accessor :current_user
  # grid.current_user para acessar o usuário
  # grid[:id] para acessar o filtro atual (no id, por exemplo)
  # grid[:created_at][0] para acessar o filtro atual quando for range true

  def check_user
    # return (!current_user.user?)
    return true
  end

  def check_admin_1
    return (current_user.id == 1)
  end

  # filter(:id, :string, if: :check_user, header: User.human_attribute_name(:id)) do |value, relation, grid|
  #   relation.by_id(value)
  # end

  filter(:name, :string, if: :check_user, header: User.human_attribute_name(:name)) do |value, relation, grid|
    relation.by_name(value)
  end

  filter(:publish_professional_profile, :enum, if: :check_user, select: [[CustomHelper.show_text_yes_no(true),1], [CustomHelper.show_text_yes_no(false),0]], header: User.human_attribute_name(:publish_professional_profile), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_publish_professional_profile(value)
  end

  filter(:professional_document_status_id, :enum, if: :check_user, select: proc { ProfessionalDocumentStatus.order(:name).map {|c| [c.name, c.id] }}, header: DataProfessional.human_attribute_name(:document_status), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_professional_document_status_id(value)
  end

  filter(:product_plan_id, :enum, if: :check_user, select: proc { Plan.by_plan_type_id(PlanType::PARA_PRODUTOS_ID).order(:name).map {|c| [c.name, c.id] }}, header: DataProfessional.human_attribute_name(:product_plan_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_product_plan_id(value)
  end

  filter(:service_plan_id, :enum, if: :check_user, select: proc { Plan.by_plan_type_id(PlanType::PARA_SERVICOS_ID).order(:name).map {|c| [c.name, c.id] }}, header: DataProfessional.human_attribute_name(:service_plan_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_service_plan_id(value)
  end

  filter(:is_blocked, :enum, if: :check_user, select: [[User.human_attribute_name(:active),0], [User.human_attribute_name(:inactive),1]], header: User.human_attribute_name(:status), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_is_blocked(value)
  end

  column(:id, order: :id, if: :check_admin_1, header: User.human_attribute_name(:id) ) do |record, grid|
    record.id
  end
  
  column(:name, order: :name, if: :check_user, header: User.human_attribute_name(:name) ) do |record, grid|
    record.get_name
  end
  
  column(:email, order: :email, if: :check_user, header: User.human_attribute_name(:email) ) do |record, grid|
    record.email
  end
  
  column(:publish_professional_profile, html: true, order: :publish_professional_profile, if: :check_user, header: User.human_attribute_name(:publish_professional_profile) ) do |record, grid|
    render "common_pages/column_yes_no", record: record.publish_professional_profile
  end
  
  column(:publish_professional_profile, html: false, order: :publish_professional_profile, if: :check_user, header: User.human_attribute_name(:publish_professional_profile) ) do |record, grid|
    CustomHelper.show_text_yes_no(record.publish_professional_profile)
  end
  
  column(:avaliations, html: true, if: :check_user, header: User.human_attribute_name(:avaliations) ) do |record, grid|
    render "avaliations", record: record
  end

  column(:professional_document_status_id, html: true, if: :check_user, header: DataProfessional.human_attribute_name(:document_status) ) do |record, grid|
    render "professional_document_status", record: record
  end

  column(:seller_verified, html: true, if: :check_user, header: User.human_attribute_name(:seller_verified) ) do |record, grid|
    render "seller_verified", record: record
  end

  column(:product_plan_id, if: :check_user, html: false, header: DataProfessional.human_attribute_name(:product_plan_id) ) do |record, grid|
    if !record.data_professional.nil? && !record.data_professional.product_plan.nil?
      record.data_professional.product_plan.name
    end
  end
  
  column(:service_plan_id, if: :check_user, html: false, header: DataProfessional.human_attribute_name(:service_plan_id) ) do |record, grid|
    if !record.data_professional.nil? && !record.data_professional.service_plan.nil?
      record.data_professional.service_plan.name
    end
  end

  column(:user_plans, if: :check_user, html: true, order: :is_blocked, header: User.human_attribute_name(:user_plans) ) do |record, grid|
    render "user_plans", record: record
  end
  
  column(:is_blocked, if: :check_user, html: true, order: :is_blocked, header: User.human_attribute_name(:status) ) do |record, grid|
    render "user_status", record: record
  end
  
  column(:actions, if: :check_user, html: true, header: User.human_attribute_name(:actions) ) do |record, grid|
    render "datagrid_actions", record: record
  end

end
