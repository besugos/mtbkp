class CategoriesGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Category.includes(:sub_categories).all
  end

  attr_accessor :current_user
  # grid.current_user para acessar o usuário

  def check_user
    # return (!current_user.user?)
    return true
  end

  filter(:name, :string, if: :check_user, header: Category.human_attribute_name(:name)) do |value, relation, grid|
    relation.by_name(value)
  end

  column(:name, if: :check_user, order: :name, header: Category.human_attribute_name(:name) ) do |record, grid|
    record.name
  end

  column(:sub_categories, if: :check_user, html: true, header: Category.human_attribute_name(:sub_categories) ) do |record, grid|
    render "show_sub_categories", record: record
  end

  column(:sub_categories, if: :check_user, html: false, header: Category.human_attribute_name(:sub_categories) ) do |record, grid|
    record.sub_categories.map(&:name).join(', ')
  end

  column(:actions, if: :check_user, html: true, header: Category.human_attribute_name(:actions) ) do |record, grid|
    render "datagrid_actions", record: record
  end

end
