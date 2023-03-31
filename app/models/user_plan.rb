class UserPlan < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  belongs_to :user
  belongs_to :plan
  belongs_to :order

  validates_presence_of :user_id, :plan_id, :initial_date
  
  def get_text_name
    self.id.to_s
  end

  def self.routine_payments
    user_plans = UserPlan.where("next_payment <= ?", Date.today).where(final_date: nil)
    system_configuration = SystemConfiguration.first
    user_plans.each do |user_plan|
      if !user_plan.order.nil? && (user_plan.quantity_months_discount.nil? || (user_plan.count_paid < user_plan.quantity_months_discount))
        begin
          order_clone = user_plan.order.amoeba_dup
          order_clone.id = nil
          new_order = Order.new(
            order_status_id: OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID, 
            user_id: order_clone.user_id,
            payment_type_id: order_clone.payment_type_id,
            seller_coupon_id: order_clone.seller_coupon_id,
            order_type_recurrent_id: order_clone.order_type_recurrent_id
            )
          if new_order.save!
            if !order_clone.card.nil?
              old_card = order_clone.card.dup
              old_card.ownertable = new_order
              old_card.save
            end
            user_plan.order.order_carts.each do |order_cart|
              new_order_cart = order_cart.dup
              new_order_cart.order_id = new_order.id
              new_order_cart.save!
            end
            new_order.save!
            service = Utils::PaymentService.new(PaymentTransaction::GATEWAY_PAGSEGURO, new_order, user_plan.user, system_configuration, nil, nil, nil, false)
            transaction = service.call
            if transaction[0]
              if transaction[1]
                first_order_cart = new_order.order_carts.first
                if first_order_cart
                  user_plan = user_plan.user.user_plans.select{|item| item.plan_id == first_order_cart.ownertable_id && item.final_date.nil?}.last
                  if !user_plan.nil? && !user_plan.quantity_months_discount.nil? && (user_plan.count_paid < user_plan.quantity_months_discount)
                    UserPlan.generate_or_update_user_plan(new_order.user, new_order)
                  else
                    if new_order.payment_type_id == PaymentType::CARTAO_CREDITO_ID
                      UserPlan.generate_or_update_user_plan(new_order.user, new_order)
                    end
                  end
                end
              end 
            end

          else
            Rails.logger.info new_order.errors.full_messages.join('<br>')
          end
        rescue Exception => e
          Rails.logger.error "-- routine_payments --"+user_plan.user_id.to_s
          Rails.logger.error e.message          
        end
      end
    end
  end

  def self.generate_or_update_user_plan(current_user, order)
    begin
      first_order_cart = order.order_carts.first
      if !first_order_cart.nil? && first_order_cart.ownertable_type == "Plan"
        order.update_columns(created_at: DateTime.now)
        # Compra de plano
        user_plan = current_user.user_plans.select{|item| item.plan_id == first_order_cart.ownertable_id && item.final_date.nil?}.last
        if order.order_type_recurrent_id == OrderTypeRecurrent::RECURRENT_ID || user_plan.count_paid < user_plan.quantity_months_discount
          next_payment = (Date.today + 1.months)
        else
          next_payment = nil
        end
        validate_date = (Date.today + 1.months)
        if user_plan
          is_renew = true
          user_plan.update_columns(
            next_payment: next_payment,
            validate_date: validate_date,
            count_paid: (user_plan.count_paid + 1),
            order_id: order.id
            )
        else
          is_renew = false
          if !order.seller_coupon.nil?
            quantity_months_discount = order.seller_coupon.quantity_months
          else
            quantity_months_discount = 1
          end
          user_plan = UserPlan.create(
            user_id: current_user.id,
            plan_id: first_order_cart.ownertable_id,
            initial_date: DateTime.now,
            price: order.get_total_price,
            next_payment: next_payment,
            validate_date: validate_date,
            count_paid: 1,
            quantity_months_discount: quantity_months_discount,
            plan_price: first_order_cart.ownertable.get_price,
            use_discount_coupon: !order.seller_coupon.nil?,
            order_id: order.id
            )
        end

        if !is_renew
          data_professional = current_user.data_professional
          if data_professional
            if first_order_cart.ownertable.plan_type_id == PlanType::PARA_PRODUTOS_ID
              quantity_products_to_register = (data_professional.quantity_products_to_register + first_order_cart.ownertable.limit_products)
              quantity_products_left = quantity_products_to_register - data_professional.quantity_products_active
              data_professional.update_columns(
                quantity_products_to_register: quantity_products_to_register,
                product_plan_id: first_order_cart.ownertable_id,
                quantity_products_left: quantity_products_left
                )
            elsif first_order_cart.ownertable.plan_type_id == PlanType::PARA_SERVICOS_ID
              quantity_services_to_register = (data_professional.quantity_services_to_register + first_order_cart.ownertable.limit_service_categories)
              quantity_services_left = quantity_services_to_register - data_professional.quantity_services_active
              data_professional.update_columns(
                quantity_services_to_register: quantity_services_to_register,
                service_plan_id: first_order_cart.ownertable_id,
                quantity_services_left: quantity_services_left
                )
            end
          end
        end

      end
    rescue Exception => e
      Rails.logger.error "-- generate_or_update_user_plan --"
      Rails.logger.error e.message
    end
  end

  private

  def default_values
    self.count_paid ||= 0
    self.plan_price ||= 0
  end

end
