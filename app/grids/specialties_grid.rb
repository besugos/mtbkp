class SpecialtiesGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Specialty.all.order(:name)
  end

  attr_accessor :current_user
  # grid.current_user para acessar o usuário
  # grid[:id] para acessar o filtro atual (no id, por exemplo)
  # grid[:created_at][0] para acessar o filtro atual quando for range true

  def check_user
    # return (!current_user.user?)
    return true
  end

  filter(:name, :string, if: :check_user, header: Specialty.human_attribute_name(:name)) do |value, relation, grid|
    relation.by_name(value)
  end

  column(:name, order: :name, if: :check_user, header: Specialty.human_attribute_name(:name) ) do |record, grid|
    record.name
  end
  
  column(:actions, if: :check_user, html: true, header: Specialty.human_attribute_name(:actions) ) do |record, grid|
    render "datagrid_actions", record: record
  end

end
