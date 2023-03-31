class CardsGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Card.all
  end

  attr_accessor :current_user, :ownertable_type, :ownertable_id, :page_title
  # grid.current_user para acessar o usuário

  def check_user
    # return (!current_user.user?)
    return true
  end

end
