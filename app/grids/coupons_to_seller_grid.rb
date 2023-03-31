class CouponsToSellerGrid

  include Datagrid

  Datagrid.configure do |config|
    config.date_formats = ["%d/%m/%Y", "%d-%m-%Y"]
    config.datetime_formats = ["%d/%m/%Y %h:%M", "%d-%m-%Y %h:%M:%s"]
  end

  scope do
    SellerCoupon.where(coupon_area_id: CouponArea::CUPOM_VENDEDOR_ID)
  end

  attr_accessor :current_user
  # grid.current_user para acessar o usuário
  # grid[:id] para acessar o filtro atual (no id, por exemplo)
  # grid[:created_at][0] para acessar o filtro atual quando for range true

  def check_user
    # return (!current_user.user?)
    return true
  end

  filter(:name, :string, if: :check_user, header: SellerCoupon.human_attribute_name(:name)) do |value, relation, grid|
    relation.by_name(value)
  end

  filter(:coupon_type_id, :string, if: :check_user, header: SellerCoupon.human_attribute_name(:coupon_type_id)) do |value, relation, grid|
    relation.by_coupon_type_id(value)
  end

  filter(:quantity, :integer, :range => true, if: :check_user, :header => SellerCoupon.human_attribute_name(:quantity)) do |value, relation, grid|
    relation.by_initial_quantity(value[0]).by_final_quantity(value[1])
  end

  filter(:validate_date, :date, :range => true, if: :check_user, :header => SellerCoupon.human_attribute_name(:validate_date)) do |value, relation, grid|
    relation.by_initial_validate_date(value[0]).by_final_validate_date(value[1])
  end

  column(:name, order: :name, if: :check_user, header: SellerCoupon.human_attribute_name(:name) ) do |record, grid|
    record.name.upcase
  end
  
  column(:coupon_type_id, if: :check_user, order: :coupon_type_id, header: SellerCoupon.human_attribute_name(:coupon_type_id) ) do |record, grid|
    if record.coupon_type
      record.coupon_type.name
    end
  end

  column(:quantity, order: :quantity, if: :check_user, header: SellerCoupon.human_attribute_name(:quantity) ) do |record, grid|
    record.quantity
  end

  column(:validate_date, order: :validate_date, if: :check_user, header: SellerCoupon.human_attribute_name(:validate_date) ) do |record, grid|
    CustomHelper.get_text_date(record.validate_date, "date", :default)
  end
  
  column(:value, order: :value, if: :check_user, header: SellerCoupon.human_attribute_name(:value) ) do |record, grid|
    if record.coupon_type_id == CouponType::PERCENTUAL_ID
      CustomHelper.to_percentage(record.value, 2)
    elsif record.coupon_type_id == CouponType::FINANCEIRO_ID
      CustomHelper.to_currency(record.value)
    end
  end

  column(:quantity_months, order: :quantity_months, if: :check_user, header: SellerCoupon.human_attribute_name(:quantity_months) ) do |record, grid|
    record.quantity_months
  end

  column(:actions, if: :check_user, html: true, header: SellerCoupon.human_attribute_name(:actions) ) do |record, grid|
    render "datagrid_actions", record: record
  end

end
