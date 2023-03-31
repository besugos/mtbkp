class ServicesGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Service.all.order(:name)
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

  filter(:name, :string, if: :check_user, header: Service.human_attribute_name(:name)) do |value, relation, grid|
    relation.by_name(value)
  end

  filter(:price, :integer, :range => true, if: :check_user, :header => Service.human_attribute_name(:price)) do |value, relation, grid|
    relation.by_initial_price(value[0]).by_final_price(value[1])
  end

  filter(:category_id, :enum, if: :check_user, select: proc { Category.by_category_type_id(CategoryType::SERVICOS_ID).order(:name).map {|c| [c.name, c.id] }}, header: Service.human_attribute_name(:category_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_category_id(value)
  end

  filter(:user_id, :enum, if: :check_admin, select: proc { User.user.order(:name).map {|c| [c.name, c.id] }}, header: Service.human_attribute_name(:user_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_user_id(value)
  end

end
