module Utils
  class PaymentService < BaseService

    def initialize(gateway, order, user, system_configuration, custom_value, custom_description, custom_due_date, recurrent)
      @gateway = gateway
      @order = order
      @user = user
      @system_configuration = system_configuration
      @custom_value = custom_value
      @custom_description = custom_description
      @custom_due_date = custom_due_date
      @recurrent = recurrent
    end

    def call
      return [false, false, I18n.t("session.invalid_data"), nil] if invalid?
      return [false, false, 'Dados do cartão inválidos', nil] if card_invalid?
      define_values
      make_payment
    end

    private

    def invalid?
      (@gateway.blank? || @gateway.nil?) ||
      (@order.blank? || @order.nil?) ||
      (@user.blank? || @user.nil?)
    end

    def card_invalid?
      (@order.payment_type_id == PaymentType::CARTAO_CREDITO_ID && @order.card.nil? && @order.get_total_price > 0)
    end

    def define_values
      @reference_id = SecureRandom.urlsafe_base64(10)
      @description = (@custom_description.nil? || @custom_description.blank?) ? 'pagamento' : @custom_description
      @value = @custom_value.nil? ? @order.get_total_price : @custom_value
      @payment_type = @order.payment_type_id
      @installments = @order.installments
      @card = @order.card
      @payer = @user
      @due_date = (@custom_due_date.nil? || @custom_due_date.blank?) ? (Date.today + 5.days) : @custom_due_date
      @recurrent = false if @recurrent.nil?
    end

    def make_payment
      if @gateway == PaymentTransaction::GATEWAY_PAGSEGURO
        service = Utils::PagSeguro::PagSeguroPaymentService.new(@order, @reference_id, @description, @value, @payment_type, @installments, @card, @payer, @due_date)
        transaction = service.call
        return transaction
      end
    end

  end
end
