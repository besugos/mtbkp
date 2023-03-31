class OrderPolicy < ApplicationPolicy

  def index?
    !user.nil? && user.admin?
  end

  def sold_products?
    !user.nil? && user.user?
  end

  def bought_plans?
    !user.nil? && (user.admin? || user.user?)
  end

  def my_orders?
    !user.nil? && (user.admin? || user.user?)
  end

  def add_item_to_order?
    true
  end

  def remove_item_to_order?
    true
  end

  def pay_order?
    !user.nil? && user.id == record.user_id && (record.order_status_id == OrderStatus::EM_ABERTO_ID || record.order_status_id == OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID)
  end

  def update?
    !record.nil? || user.id == record.user_id && (record.order_status_id != OrderStatus::EM_ABERTO_ID && record.order_status_id != OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID)
  end

  def edit?
    update?
  end

  def show?
    update?
  end

  def show_order_cart?
    update?
  end

  def destroy?
    Rails.env.development? || (!user.nil? && user.id == 1)
  end

  def can_cancel_user_plan?(user_plan)
    user.admin? && !user_plan.next_payment.nil? && user_plan.next_payment >= Date.today
  end

  def open_chat?
    array_sellers = Order.get_order_formatted_by_sellers(record)
    user.admin? || (user.id == record.user_id || array_sellers.map(&:id).include?(user.id))
  end

end
