class OrdersController < ApplicationController

  skip_before_action :authenticate_user, only: [:update, :save_new_external_order, :add_item_to_order, :remove_item_to_order, :show_order_cart, :pay_order]

  before_action :set_order, only: [:edit, :update, :destroy, :get_order, :check_payment, :update_freight]

  def index
    authorize Order

    if params[:orders_grid].nil? || params[:orders_grid].blank?
      @orders = OrdersGrid.new(:current_user => @current_user)
      @orders_to_export = OrdersGrid.new(:current_user => @current_user)
    else
      @orders = OrdersGrid.new(params[:orders_grid].merge(current_user: @current_user))
      @orders_to_export = OrdersGrid.new(params[:orders_grid].merge(current_user: @current_user))
    end

    if @current_user.admin?
      @orders.scope {|scope| scope.page(params[:page]) }
    elsif @current_user.user?
      @orders.scope {|scope| scope.where(user_id: @current_user.id).page(params[:page]) }
      @orders_to_export.scope {|scope| scope.where(user_id: @current_user.id)}
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data @orders_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Order.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end

  end

  def sold_products
    authorize Order

    if params[:sold_products_grid].nil? || params[:sold_products_grid].blank?
      @orders = SoldProductsGrid.new(:current_user => @current_user)
      @orders_to_export = SoldProductsGrid.new(:current_user => @current_user)
    else
      @orders = SoldProductsGrid.new(params[:sold_products_grid].merge(current_user: @current_user))
      @orders_to_export = SoldProductsGrid.new(params[:sold_products_grid].merge(current_user: @current_user))
    end

    if @current_user.admin?
      @orders.scope {|scope| scope.page(params[:page]) }
    elsif @current_user.user?
      all_products_ids = Product.where(user_id: @current_user.id).map(&:id)
      order_carts = OrderCart.where(ownertable_id: [all_products_ids]).map(&:id)
      if order_carts.length > 0
        @orders.scope {|scope| scope.joins(:order_carts).where(order_carts: {id: [order_carts]}).page(params[:page])}
        @orders_to_export.scope {|scope| scope.joins(:order_carts).where(order_carts: {id: [order_carts]})}
      else
        @orders.scope {|scope| scope.where(id: -1).page(params[:page])}
        @orders_to_export.scope {|scope| scope.where(id: -1)}
      end
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data @orders_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Order.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end

  end

  def bought_plans
    authorize Order

    if params[:bought_plans_grid].nil? || params[:bought_plans_grid].blank?
      @orders = BoughtPlansGrid.new(:current_user => @current_user)
      @orders_to_export = BoughtPlansGrid.new(:current_user => @current_user)
    else
      @orders = BoughtPlansGrid.new(params[:bought_plans_grid].merge(current_user: @current_user))
      @orders_to_export = BoughtPlansGrid.new(params[:bought_plans_grid].merge(current_user: @current_user))
    end

    if @current_user.admin?
      @orders.scope {|scope| scope.page(params[:page]) }
    elsif @current_user.user?
      @orders.scope {|scope| scope.by_user_id(@current_user.id).page(params[:page])}
      @orders_to_export.scope {|scope| scope.by_user_id(@current_user.id)}
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data @orders_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Order.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end

  end

  def my_orders
    authorize Order

    if params[:my_orders_grid].nil? || params[:my_orders_grid].blank?
      @orders = MyOrdersGrid.new(:current_user => @current_user)
      @orders_to_export = MyOrdersGrid.new(:current_user => @current_user)
    else
      @orders = MyOrdersGrid.new(params[:my_orders_grid].merge(current_user: @current_user))
      @orders_to_export = MyOrdersGrid.new(params[:my_orders_grid].merge(current_user: @current_user))
    end

    @orders.scope {|scope| scope.by_user_id(@current_user.id).page(params[:page])}
    @orders_to_export.scope {|scope| scope.by_user_id(@current_user.id)}
    
    respond_to do |format|
      format.html
      format.csv do
        send_data @orders_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Order.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end

  end

  def edit
    authorize @order
  end

  def update
    @order.update(order_params)
    if @order.valid?
      Order.validate_order_cart_quantity(@order)
      if !order_params[:address_id].nil? && !order_params[:address_id].blank?
        Order.validate_address_payment(@order, nil, order_params[:address_id])
        if @order.order_status_id == OrderStatus::EM_ABERTO_ID && 
          @order.freight_orders.destroy_all
          @order.update_columns(zipcode_delivery: @order.address.zipcode)
          Order.get_calculate_freigth_value(@order, @order.address.zipcode)
        end
      end
      redirect_to show_order_cart_path
    else
      flash[:error] = @order.errors.full_messages.join('<br>')
      render :edit
    end
  end

  def update_freight
    old_freight_order_status_id = nil
    freight_order_option = nil
    current_id_freight_order = order_params[:freight_orders_attributes]["0"][:id]
    old_freight_order = FreightOrder.where(id: current_id_freight_order).first
    if !old_freight_order.nil?
      freight_order_option = Order.get_freight_order_option_object_by_seller(old_freight_order.order, old_freight_order.seller)
      if !freight_order_option.nil?
        old_freight_order_status_id = freight_order_option.freight_order_status_id
      end
    end
    @order.update(order_params)
    if @order.valid?
      if !old_freight_order.nil? && !freight_order_option.nil?
        freight_order_option.reload
        if old_freight_order_status_id != FreightOrderStatus::ENTREGUE_ID && freight_order_option.freight_order_status_id == FreightOrderStatus::ENTREGUE_ID
          old_freight_order.update_columns(limit_cancel_order: DateTime.now + 7.days)
        else
          old_freight_order.update_columns(limit_cancel_order: nil)
        end
      end
      flash[:success] = t('flash.update')
      redirect_to order_path(@order)
    else
      flash[:error] = @order.errors.full_messages.join('<br>')
      redirect_to order_path(@order)
    end
  end

  def destroy
    authorize Order
    if @order.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @order.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def get_order
    data = {
      result: @order
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def add_item_to_order
    result = Order.add_element_to_order(@order, params[:ownertable_type], params[:ownertable_id], params[:quantity])
    
    if result[0]
      flash[:success] = result[1]
    else
      flash[:error] = result[1]
    end

    data = {
      result: result[0],
      message: result[1]
    }

    respond_to do |format|
      format.html {redirect_to show_order_cart_path}
      format.json {render :json => data, :status => 200}
    end
    
  end

  def remove_item_to_order
    result = Order.remove_element_to_order(@order, params[:order_cart_id])
    if result[0]
      flash[:success] = result[1]
    else
      flash[:error] = result[1]
    end
    redirect_to show_order_cart_path
  end

  def add_plan_to_buy
    if @current_user.is_valid_to_buy_plan?
      @order_buy_plan.order_carts.destroy_all
      result = Order.add_element_to_order(@order_buy_plan, params[:ownertable_type], params[:ownertable_id], params[:quantity])
      if result[0]
        flash[:success] = result[1]
      else
        flash[:error] = result[1]
      end
      redirect_to pay_order_path(id: @order_buy_plan.id)
    else
      flash[:error] = Order.human_attribute_name(:needs_approvation_to_buy_plan)
      redirect_to edit_user_path(@current_user)
    end
  end

  def show
    @current_order = Order.where(id: params[:id]).first
  end

  def show_order_cart
    authorize @order
    @current_order = @order
    @current_order.order_carts.each do |order_cart|
      order_cart.save
    end
    @current_order.save!
  end

  def save_address_to_buy
    define_current_order
    Order.validate_address_payment(@current_order, order_params[:address_attributes], order_params[:address_id])
    if @current_order.valid?
      @current_order.order_carts.each do |order_cart|
        order_cart.save
      end
      if (@current_order.zipcode_delivery.nil? || @current_order.zipcode_delivery.blank? && !@current_order.address.nil?)
        @current_order.update_columns(zipcode_delivery: @current_order.address.zipcode)
      end
      if @current_order.order_status_id == OrderStatus::EM_ABERTO_ID && CustomHelper.get_clean_text(@current_order.zipcode_delivery) != CustomHelper.get_clean_text(order_params[:address_attributes][:zipcode])
        @current_order.freight_orders.destroy_all
        @current_order.update_columns(zipcode_delivery: order_params[:address_attributes][:zipcode])
        Order.get_calculate_freigth_value(@current_order, order_params[:address_attributes][:zipcode])
      end
      flash[:success] = Order.human_attribute_name(:address_saved_sucess)
      redirect_to pay_order_path(id: @current_order.id, show_pay_data: true)
    else
      flash[:error] = @current_order.errors.full_messages.join('<br>')
      redirect_to pay_order_path(id: @order.id, show_address_data: true)
    end
  end
  
  def pay_order
    define_current_order
    if @current_user.nil?
      session[:current_pay_order] = @current_order.id
      redirect_to login_path
    else
      if !@current_order.nil? && (@current_order.order_status_id == OrderStatus::EM_ABERTO_ID || @current_order.order_status_id == OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID) && @current_order.user_id != @current_user.id
        @current_order.update_columns(user_id: @current_user.id)
      end
      authorize @current_order
      Order.generate_order_melhor_envio(@current_order)
      
      if @current_order.order_status_id == OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID && !@current_user.is_valid_to_buy_plan?
        flash[:error] = Order.human_attribute_name(:needs_approvation_to_buy_plan)
        redirect_to edit_user_path(@current_user)
      else
        if !Order.validate_freight_to_buy_products(@current_order)
          flash[:error] = Order.human_attribute_name(:freight_necessary)
          redirect_to show_order_cart_path
        else
          @current_user.skip_validate_password = true
          if !@current_user.valid?
            flash[:error] = @current_user.errors.full_messages.join('<br>')
            redirect_to edit_user_path(@current_user)
          else
            @current_order.update_columns(user_id: @current_user.id)
            Order.validate_order_cart_quantity(@current_order)
            @current_order = build_initial_relations(@current_order)
          end
        end
      end
    end
  end

  def make_payment
    define_current_order
    @current_order.update(order_params)
    Order.validate_order_cart_quantity(@current_order)
    Order.validate_card_payment(@current_order, order_params[:card_attributes], order_params[:card_id])
    @current_order.reload
    
    service = Utils::PaymentService.new(PaymentTransaction::GATEWAY_PAGSEGURO, @current_order, @current_user, @system_configuration, nil, nil, nil, false)
    transaction = service.call

    if transaction[0]
      if transaction[1]
        flash[:success] = transaction[2]
        if @current_order.payment_type_id == PaymentType::CARTAO_CREDITO_ID
          UserPlan.generate_or_update_user_plan(@current_order.user, @current_order)
          # Order.setting_limit_cancel_order(@current_order)
          first_order_cart = @current_order.order_carts.first
          if !first_order_cart.nil? && first_order_cart.ownertable_type == "Plan"
            if first_order_cart.ownertable.plan_type_id == PlanType::PARA_PRODUTOS_ID
              redirect_to products_path
            elsif first_order_cart.ownertable.plan_type_id == PlanType::PARA_SERVICOS_ID
              redirect_to services_path
            end
          else
            Order.generate_order_melhor_envio(@current_order)
            redirect_to order_path(@current_order)
          end
        else
          redirect_to order_path(@current_order)
        end
      else
        flash[:error] = transaction[2]
        redirect_to pay_order_path(id: @current_order)
      end
    else
      flash[:error] = transaction[2]
      redirect_to pay_order_path(id: @current_order)
    end

  end

  def define_current_order
    if !params[:id].nil? && !params[:id].blank?
      @current_order = Order.where(id: params[:id]).first
      if @current_order.user.nil? && !@current_user.nil?
        @current_order.update_columns(user_id: @current_user.id)
      end
    else
      if @current_user.nil?
        @order.save!
        @current_order = @order
      elsif !session[:current_order_id].nil?
        @current_order = Order.where(id: session[:current_order_id]).first
      else
        @order.user_id = @current_user.id
        @order.save!
        @current_order = @order
      end
    end
  end

  def build_initial_relations(current_order)
    current_order.card.destroy if !current_order.card.nil?
    current_order.build_card if current_order.card.nil?
    current_order.build_address if current_order.address.nil?
    return current_order
  end

  def check_payment
    @current_order = @order
    last_payment_transaction = @current_order.payment_transactions.last
    if last_payment_transaction
      service = Utils::PagSeguro::PagSeguroGetPaymentStatusService.new(@current_order, last_payment_transaction)
      transaction = service.call
    end
    redirect_to order_path(@current_order)
  end

  def insert_seller_coupon
    data = nil
    begin
      current_order = Order.where(id: params[:current_order_to_pay_id]).first
      if current_order
        seller_coupon = SellerCoupon.active.by_coupon_area_id(CouponArea::CUPOM_VENDEDOR_ID)
        .by_exactly_name(params[:text_seller_coupon].downcase).first
        if seller_coupon
          current_order.update_columns(seller_coupon_id: seller_coupon.id)
          current_order.save!
          data = {
            result: true,
            message: Order.human_attribute_name(:seller_coupon_added_with_success)
          }
        end
      end
    rescue Exception => e
      data = {
        result: false,
        message: e.message
      }
    end

    if data.nil?
      data = {
        result: false,
        message: Order.human_attribute_name(:seller_coupon_added_with_failed)
      }
    end

    # Encaminha a resposta
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def insert_discount_coupon
    data = nil
    begin
      current_order = Order.where(id: params[:current_order_to_pay_id]).first
      if current_order
        discount_coupon = SellerCoupon.active.by_coupon_area_id(CouponArea::CUPOM_DESCONTO_ID)
        .by_exactly_name(params[:text_discount_coupon].downcase).first
        if discount_coupon

          discount_coupon_seller_ids = discount_coupon.users.map(&:id).uniq
          order_cart_seller_ids = current_order.order_carts.select{|item| discount_coupon_seller_ids.include?(item.ownertable.user_id) }
          
          order_cart_seller_ids.each do |order_cart|
            order_cart.seller_coupon_id = discount_coupon.id
            order_cart.save!
          end

          data = {
            result: true,
            message: Order.human_attribute_name(:discount_coupon_added_with_success)
          }
        end
      end
    rescue Exception => e
      data = {
        result: false,
        message: e.message
      }
    end

    if data.nil?
      data = {
        result: false,
        message: Order.human_attribute_name(:discount_coupon_added_with_failed)
      }
    end

    # Encaminha a resposta
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def remove_seller_coupon
    define_current_order
    @current_order.update_columns(seller_coupon_id: nil)
    @current_order.save!
    redirect_back(fallback_location: :back)
  end

  def remove_discount_coupon
    define_current_order
    seller_coupon_id = params[:seller_coupon_id]
    order_carts = @current_order.order_carts.select{|item| item.seller_coupon_id == seller_coupon_id.to_i}
    order_carts.each do |order_cart|
      order_cart.update_columns(seller_coupon_id: nil)
      order_cart.save!
    end
    @current_order.save!
    redirect_back(fallback_location: :back)
  end

  def get_freight_values
    define_current_order
    begin
      postalcode_to = params[:postalcode_to].gsub(/[.,-]/, "")
      postalcode_invalid = !(postalcode_to.length == 8 && !!(postalcode_to =~ /\A[-+]?[0-9]+\z/))
      if !postalcode_invalid
        if @current_order.zipcode_delivery != params[:postalcode_to]
          @current_order.freight_orders.destroy_all
        end
        Order.get_calculate_freigth_value(@current_order, postalcode_to)
        @current_order.update_columns(zipcode_delivery: postalcode_to)
        @current_order.address.destroy if !@current_order.address.nil?
        address = Address.new
        address.zipcode = params[:postalcode_to]
        address.ownertable = @current_order
        address.skip_validate = true
        address.save!
      end
      data = {
        result: true,
        message: ""
      }
    rescue Exception => e
      Rails.logger.error "-- get_freight_values --"
      Rails.logger.error e.message
      data = {
        result: false,
        message: e.message
      }
    end

    # Encaminha a resposta
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def updating_freight_select
    define_current_order
    begin
      freight_order_options = FreightOrderOption.where(freight_order_id: params[:freight_order_id])
      freight_order_options.update_all(selected: false)
      data = {
        result: true,
        message: ""
      }
    rescue Exception => e
      Rails.logger.error "-- updating_freight_select --"
      Rails.logger.error e.message
      data = {
        result: false,
        message: e.message
      }
    end

    # Encaminha a resposta
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def cancel_user_plan
    user_plan = UserPlan.where(id: params[:id]).first
    if user_plan && policy(Order).can_cancel_user_plan?(user_plan)
      user_plan.update_columns(next_payment: nil)
      flash[:success] = "Plano cancelado com sucesso."
      redirect_back(fallback_location: :back)
    else
      user_not_authorized
    end
  end

  def chats
    authorize @current_user
    define_current_order
    if params[:user_id] && !@current_order.nil? && policy(@current_order).open_chat?
      # Usuário receptor
      @current_user_chat = User.where(id: params[:user_id])
      .first
      if @current_user_chat && policy(@current_user_chat).open_chat?(@current_user_chat)
        @last_message = @current_order.messages.last
        @messages = Message
        .getting_messages(@current_user.id, params[:user_id])
        .where(order_id: @current_order.id)
        .limit(100)
        .order('created_at DESC')
        .reverse
        # Marcando mensagens como lida
        User.mark_all_as_read(@current_user, @current_user_chat)
      else
        flash[:error] = "Sem permissão"
        redirect_to root_path
      end
    end
  end

  def update_professional_avaliation
    @professional_avaliation = ProfessionalAvaliation.where(id: professional_avaliation_params[:id]).first
    if @professional_avaliation
      @professional_avaliation.update(professional_avaliation_params)
      if @professional_avaliation.valid?
        flash[:success] = "Avaliação salva com sucesso."
        redirect_to order_path(@professional_avaliation.order)
      else
        flash[:error] = @professional_avaliation.errors.full_messages.join('<br>')
        redirect_to order_path(@professional_avaliation.order)
      end
    else
      user_not_authorized
    end
  end

  def request_cancel_order
    @cancel_order = CancelOrder.where(id: cancel_order_params[:id]).first
    if @cancel_order
      @cancel_order.update(cancel_order_params)
      if @cancel_order.valid?
        flash[:success] = "Requisição de cancelamento feita com sucesso!"
        CancelOrder.cancel_order(@cancel_order, @current_user)
        redirect_to chats_path(id: @cancel_order.order.id, user_id: @cancel_order.freight_order.seller_id)
      else
        flash[:error] = @cancel_order.errors.full_messages.join('<br>')
        redirect_to order_path(@cancel_order.order)
      end
    else
      user_not_authorized
    end
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def order_params
    params.require(:order).permit(:id, :price, :order_status_id, 
      :user_id, :installments, :payment_type_id, :total_freight_value, :card_id, :address_id,
      :zipcode_delivery, :order_type_recurrent_id,
      order_carts_attributes: [:id, :order_id, :ownertable_type, :ownertable_id, :quantity, :unity_price, :total_value, :freight_value, :freight_value_total],
      card_attributes: [:id, :card_banner_id, :name, :number, :validate_date_month, :validate_date_year, :ccv_code],
      address_attributes: [ :id, :validate_to_order, :address_type_id, :name, :zipcode, :address, :district, :number, :complement, :address_type, :state_id, :city_id, :country_id, :reference],
      freight_orders_attributes: [
        :id,
        :order_id, 
        :seller_id,
        freight_order_options_attributes: [
          :id,
          :freight_order_id,
          :name,
          :price,
          :delivery_time,
          :freight_company_id,
          :selected,
          :tracking_code,
          :freight_order_status_id,
          :melhor_envio_service_id
        ]
      ]
      )
  end

  def professional_avaliation_params
    params
    .require(:professional_avaliation)
    .permit(:id,
      :order_id,
      :professional_id,
      :client_id,
      :deadline_avaliation,
      :quality_avaliation, 
      :problems_solution_avaliation, 
      :comment)
  end

  def cancel_order_params
    params
    .require(:cancel_order)
    .permit(:id,
      :cancel_order_reason_id,
      :reason_text)
  end

end
