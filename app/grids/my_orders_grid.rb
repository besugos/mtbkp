class MyOrdersGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Order.includes(:user)
    .includes(:order_status)
    .where.not(order_status_id: [OrderStatus::EM_ABERTO_ID, OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID])
    .bought_products
    .order(created_at: :desc)
    .group(:id)
  end
  
  attr_accessor :current_user
  # grid.current_user para acessar o usuário

  def check_user
    # return (!current_user.user?)
    return true
  end

  filter(:id, :string, if: :check_user, header: Order.human_attribute_name(:id)) do |value, relation, grid|
    relation.by_id(value)
  end

  filter(:created_at, :date, :range => true, if: :check_user, :header => Order.human_attribute_name(:created_at)) do |value, relation, grid|
    relation.by_initial_date(value[0]).by_final_date(value[1])
  end

  filter(:payment_type_id, :enum, if: :check_user, select: proc { PaymentType.order(:id).map {|c| [c.name, c.id] }}, header: Order.human_attribute_name(:payment_type_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_payment_type_id(value)
  end

  filter(:order_status_id, :enum, if: :check_user, select: proc { OrderStatus.where(id: [OrderStatus::PAGAMENTO_REALIZADO_ID, OrderStatus::AGUARDANDO_PAGAMENTO_ID]).order(:id).map {|c| [c.name, c.id] }}, header: Order.human_attribute_name(:order_status_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_order_status_id(value)
  end

  column(:id, if: :check_user, html: false, order: :id, header: Order.human_attribute_name(:id) ) do |record, grid|
    record.id
  end

  column(:id, if: :check_user, html: true, order: :id, header: Order.human_attribute_name(:id) ) do |record, grid|
    link_to "#"+record.id.to_s, order_path(record), target: "_blank"
  end

  column(:created_at, if: :check_user, order: :created_at, header: Order.human_attribute_name(:created_at) ) do |record, grid|
    CustomHelper.get_text_date(record.created_at, 'datetime', :full)
  end

  column(:price, if: :check_user, order: :price, header: Order.human_attribute_name(:price) ) do |record, grid|
    CustomHelper.to_currency(record.get_total_price)
  end

  column(:payment_type_id, if: :check_user, order: :payment_type_id, header: Order.human_attribute_name(:payment_type_id) ) do |record, grid|
    if record.payment_type
      record.payment_type.name
    end
  end

  column(:order_status_id, if: :check_user, html: false, order: :order_status_id, header: Order.human_attribute_name(:order_status_id) ) do |record, grid|
    if record.order_status
      record.order_status.name
    end
  end

  column(:order_status_id, if: :check_user, html: true, order: :order_status_id, header: Order.human_attribute_name(:order_status_id) ) do |record, grid|
    render "order_status", record: record
  end

end
