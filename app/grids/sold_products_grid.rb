class SoldProductsGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Order.includes(:user)
    .bought_products
    .includes(:order_status)
    .where.not(order_status_id: [OrderStatus::EM_ABERTO_ID,OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID])
    .order(created_at: :desc)
  end
  
  attr_accessor :current_user
  # grid.current_user para acessar o usuário

  def check_user
    # return (!current_user.user?)
    return true
  end

  def check_client
    return current_user.admin?
  end

  def get_clients
    if current_user.admin?
      return User.where.not(id: 1).order(:name).map {|c| [c.get_name, c.id] }
    elsif current_user.user?
      all_products_ids = Product.where(user_id: current_user.id).map(&:id)
      all_clients = Order.by_seller_id(all_products_ids).map(&:user_id)
      return User.user.where(id: [all_clients]).order(:name).map {|c| [c.get_name, c.id] }
    end
  end

  filter(:id, :string, if: :check_user, header: Order.human_attribute_name(:id)) do |value, relation, grid|
    relation.by_id(value)
  end

  filter(:user_id, :enum, if: :check_client, select: :get_clients, header: Order.human_attribute_name(:user_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_user_id(value)
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
    render "access_order", record: record
  end

  column(:user_id, order: :user_id, header: Order.human_attribute_name(:user_id) ) do |record, grid|
    # grid.current_user para acessar o usuário
    if record.user
      record.user.name
    end
  end

  column(:created_at, if: :check_user, order: :created_at, header: Order.human_attribute_name(:created_at) ) do |record, grid|
    CustomHelper.get_text_date(record.created_at, 'datetime', :full)
  end

  column(:price, if: :check_user, order: :price, header: Order.human_attribute_name(:price) ) do |record, grid|
    CustomHelper.to_currency(Order.get_order_price_by_seller(record, grid.current_user))
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
