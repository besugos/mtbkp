module Utils
  module PagSeguro
    class PagSeguroGetPaymentStatusService < BaseService

      def initialize(order, payment_transaction)
        @order = order
        @payment_transaction = payment_transaction
      end

      def call
        return [false, false, I18n.t("session.invalid_data")] if invalid?
        define_environment_data
        get_payment
      end

      private

      def invalid?
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        (@order.blank? || @order.nil?) ||
        (@payment_transaction.blank? || @payment_transaction.nil?) ||
        transaction.nil?
      end

      def define_environment_data
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        @url = transaction[0]
        @token = transaction[1]
      end

      def get_payment
        begin
          url = URI(@url+"/charges/"+@payment_transaction.payment_code)

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Get.new(url)
          request["Content-Type"] = "application/json"
          request["x-api-version"] = "4.0"
          request["Authorization"] = @token

          response = https.request(request)
          transaction = JSON.parse(response.read_body)
          return check_payment_transaction(transaction)
        rescue Exception => e
          return [false, false, PaymentTransaction.human_attribute_name(:failed)]
        end
      end

      def check_payment_transaction(transaction)
        payment_status = @payment_transaction.payment_status_id
        paid = false
        message = ''
        if !transaction.nil? && transaction["message"] != "Unauthorized" && transaction["error_messages"].nil?
          payment_status = transaction["status"]
          if payment_status == 'WAITING'
            message = PaymentTransaction.human_attribute_name(:waiting_payment)
          elsif payment_status == 'CANCELED'
            close_payment
            message = PaymentTransaction.human_attribute_name(:unpaid)
          elsif payment_status == 'PAID'
            confirm_payment
            message = PaymentTransaction.human_attribute_name(:paid)
            paid = true
          end
        end
        return [true, paid, message]
      end

      def confirm_payment
        @payment_transaction.update_columns(payment_status_id: PaymentStatus::PAGO_ID)
        @order.update_columns(order_status_id: OrderStatus::PAGAMENTO_REALIZADO_ID)
      end

      def close_payment
        @payment_transaction.update_columns(payment_status_id: PaymentStatus::NAO_PAGO_ID)
        @order.update_columns(order_status_id: OrderStatus::CANCELADA_ID)
      end

    end
  end
end
