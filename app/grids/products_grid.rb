class ProductsGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Product.all
  end

  attr_accessor :current_user
  # grid.current_user para acessar o usuário

  def check_user
    # return (!current_user.user?)
    return true
  end

  def check_admin
    return (!current_user.user?)
  end

  filter(:title, :string, if: :check_user, header: Product.human_attribute_name(:title)) do |value, relation, grid|
    relation.by_title(value)
  end

  filter(:category_id, :enum, if: :check_user, select: proc { Category.by_category_type_id(CategoryType::PRODUTOS_ID).order(:name).map {|c| [c.name, c.id] }}, header: Product.human_attribute_name(:category_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_category_id(value)
  end

  filter(:sub_category_id, :enum, if: :check_user, select: proc { SubCategory.order(:name).map {|c| [c.name, c.id] }}, header: Product.human_attribute_name(:sub_category_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_sub_category_id(value)
  end

  filter(:product_condition_id, :enum, if: :check_user, select: proc { ProductCondition.order(:name).map {|c| [c.name, c.id] }}, header: Product.human_attribute_name(:product_condition_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_product_condition_id(value)
  end

  filter(:user_id, :enum, if: :check_admin, select: proc { User.user.order(:name).map {|c| [c.name, c.id] }}, header: Product.human_attribute_name(:user_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_user_id(value)
  end

  column(:user_id, if: :check_admin, order: :user_id, header: Product.human_attribute_name(:user_id) ) do |record, grid|
    if record.user
      record.user.name
    end
  end

  column(:title, if: :check_user, order: :title, header: Product.human_attribute_name(:title) ) do |record, grid|
    record.get_text_name
  end

  column(:category_id, if: :check_user, order: :category_id, header: Product.human_attribute_name(:category_id) ) do |record, grid|
    if record.category
      record.category.name
    end
  end

  column(:sub_category_id, if: :check_user, order: :sub_category_id, header: Product.human_attribute_name(:sub_category_id) ) do |record, grid|
    if record.sub_category
      record.sub_category.name
    end
  end

  column(:product_condition_id, if: :check_user, order: :product_condition_id, header: Product.human_attribute_name(:product_condition_id) ) do |record, grid|
    if record.product_condition
      record.product_condition.name
    end
  end

  column(:quantity_stock, if: :check_user, order: :quantity_stock, header: Product.human_attribute_name(:quantity_stock) ) do |record, grid|
    record.quantity_stock
  end

  column(:description, if: :check_user, order: :description, header: Product.human_attribute_name(:description) ) do |record, grid|
    record.description.truncate(200)
  end

  column(:price, if: :check_user, order: :price, header: Product.human_attribute_name(:price) ) do |record, grid|
    CustomHelper.to_currency(record.get_price)
  end

  column(:actions, if: :check_user, html: true, header: Product.human_attribute_name(:actions) ) do |record, grid|
    render "datagrid_actions", record: record
  end

end
