class PlansGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Plan.all
  end

  attr_accessor :current_user, :plan_type_id
  # grid.current_user para acessar o usuário

  def check_user
    # return (!current_user.user?)
    return true
  end

  def check_plan_type_product
    return plan_type_id.to_i == PlanType::PARA_PRODUTOS_ID
  end

  def check_plan_type_service
    return plan_type_id.to_i == PlanType::PARA_SERVICOS_ID
  end

  filter(:name, :string, if: :check_user, header: Plan.human_attribute_name(:name)) do |value, relation, grid|
    relation.by_name(value)
  end

  filter(:active, :enum, if: :check_user, select: [[CustomHelper.show_text_yes_no(true),1], [CustomHelper.show_text_yes_no(false),0]], header: Plan.human_attribute_name(:active), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_active(value)
  end

  column(:name, if: :check_user, order: :name, header: Plan.human_attribute_name(:name) ) do |record, grid|
    record.name
  end

  column(:plan_periodicity_id, if: :check_user, order: :plan_periodicity_id, header: Plan.human_attribute_name(:plan_periodicity_id) ) do |record, grid|
    record.plan_periodicity.name unless record.plan_periodicity.nil?
  end

  column(:limit_products, if: :check_plan_type_product, order: :limit_products, header: Plan.human_attribute_name(:limit_products) ) do |record, grid|
    record.limit_products
  end

  column(:limit_service_categories, if: :check_plan_type_service, order: :limit_service_categories, header: Plan.human_attribute_name(:limit_service_categories) ) do |record, grid|
    record.limit_service_categories
  end

  column(:description, if: :check_user, order: :description, header: Plan.human_attribute_name(:description) ) do |record, grid|
    record.description.truncate(100)
  end

  column(:price, if: :check_user, order: :price, header: Plan.human_attribute_name(:price) ) do |record, grid|
    CustomHelper.to_currency(record.price)
  end

  column(:active, if: :check_user, html: true, order: :active, header: Plan.human_attribute_name(:active) ) do |record, grid|
    render "common_pages/column_yes_no", record: record.active
  end

  column(:active, if: :check_user, html: false, order: :active, header: Plan.human_attribute_name(:active) ) do |record, grid|
    CustomHelper.show_text_yes_no(record.active)
  end
  
  column(:actions, if: :check_user, html: true, header: Plan.human_attribute_name(:actions) ) do |record, grid|
    render "datagrid_actions", record: record
  end

end
