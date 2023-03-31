class BannersGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    Banner.all
  end

  attr_accessor :current_user
  # grid.current_user para acessar o usuário

  def check_user
    # return (!current_user.user?)
    return true
  end

  filter(:banner_area_id, :enum, if: :check_user, select: proc { BannerArea.order(:name).map {|c| [c.name, c.id] }}, header: Banner.human_attribute_name(:banner_area_id), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_banner_area_id(value)
  end

  filter(:title, :string, if: :check_user, header: Banner.human_attribute_name(:title)) do |value, relation, grid|
    relation.by_title(value)
  end

  filter(:active, :enum, if: :check_user, select: [[Banner.human_attribute_name(:visible),1], [Banner.human_attribute_name(:hidden),0]], header: Banner.human_attribute_name(:status), include_blank: I18n.t('model.select_option') ) do |value, relation, grid|
    relation.by_active(value)
  end

  column(:banner_area_id, if: :check_user, order: :banner_area_id, header: Banner.human_attribute_name(:banner_area_id) ) do |record, grid|
    if record.banner_area
      record.banner_area.name
    end
  end

  column(:position, order: :position, if: :check_user, header: Banner.human_attribute_name(:position) ) do |record, grid|
    record.position
  end

  column(:title, order: :title, if: :check_user, header: Banner.human_attribute_name(:title) ) do |record, grid|
    record.title
  end

  column(:image, if: :check_user, html: true, header: Banner.human_attribute_name(:image) ) do |record, grid|
    render "common_pages/show_image", record: record.image, resize_to_limit: [100,100], alt: ""
  end

  column(:image_mobile, if: :check_user, html: true, header: Banner.human_attribute_name(:image_mobile) ) do |record, grid|
    render "common_pages/show_image", record: record.image_mobile, resize_to_limit: [100,100], alt: ""
  end

  column(:link, if: :check_user, html: true, header: Banner.human_attribute_name(:link) ) do |record, grid|
    render "common_pages/show_link", link: record.link, text: record.link, target: "_blank"
  end
  
  column(:active, order: :active, html: false, if: :check_user, header: Banner.human_attribute_name(:status) ) do |record, grid|
    record.get_active_text
  end
  
  column(:active, order: :active, html: true, if: :check_user, header: Banner.human_attribute_name(:status) ) do |record, grid|
    render "active", record: record
  end
  
  column(:actions, if: :check_user, html: true, header: Banner.human_attribute_name(:actions) ) do |record, grid|
    render "datagrid_actions", record: record
  end

end
