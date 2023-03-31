class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  include Pundit::Authorization
  # Rescue the Pundit exception and redirectos to user_not_authorized method
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception

  before_action :authenticate_user, :current_user, 
  :get_system_configuration, :validate_new_order,
  :set_action_cable_identifier

  # Tempo para deslogar o usuário por inatividade (Descomentar caso queira o timeout)
  # auto_session_timeout 10.hour

  def get_data_to_show(banner_area_id)
    banners = Banner.active.by_banner_area_id(banner_area_id)
    if banners.length == 0
      banners = Banner.active.by_banner_area_id(BannerArea::PAGINA_INICIAL_ID)
    end
    @banners_formatted_to_show = Banner.get_array_banners_to_show(banners)
  end

  private
  def current_user
  	@current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end

  def authenticate_user
  	if !current_user
  		redirect_to login_path
  	end
  end

  def user_not_authorized
    # TO DO defines what to do when a user have access blocked by Pundit
    flash[:error] = t('flash.login_error')
    redirect_to root_path
  end

  # Buscando model de configuração do sistema
  def get_system_configuration
    @system_configuration = SystemConfiguration.find_or_create_by(id: 1)
  end

  # Gerando um novo carrinho ou buscando o carrinho atual
  def validate_new_order
    # Carrinho para compra de produtos
    @order = Order.where(id: session[:order_id]).where(order_status_id: OrderStatus::EM_ABERTO_ID).first
    if @order.nil?
      @order = Order.create(order_status_id: OrderStatus::EM_ABERTO_ID)
      session[:order_id] = @order.id
    end

    # Carrinho para compra de planos
    @order_buy_plan = Order.where(id: session[:order_buy_plan_id]).where(order_status_id: OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID).first
    if @order_buy_plan.nil?
      @order_buy_plan = Order.create(order_status_id: OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID)
      session[:order_buy_plan_id] = @order_buy_plan.id
    end
  end

  def set_action_cable_identifier
    cookies.encrypted[:user_id] = current_user&.id
  end
  
end
