module Utils
  module PagSeguro
    class PagSeguroCancelPaymentService < BaseService

      def initialize(payment_transaction, value)
        @value = nil
        @payment_transaction = payment_transaction
        if !value.nil? && !value.blank?
          @value = value
        elsif !payment_transaction.nil? && !payment_transaction.value.nil? && !payment_transaction.value.blank?
          @value = @payment_transaction.value
        end
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        cancel_payment
      end

      private

      def invalid?
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        (@payment_transaction.nil? || @payment_transaction.blank?) || 
        (@value.nil? || @value.blank?) || 
        transaction.nil?
      end

      def define_environment_data
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        @url = transaction[0]
        @token = transaction[1]
      end

      def cancel_payment
        begin

          values = {
            amount: {
              value: (@value * 100).to_i
            }
          }.to_json

          url = URI(@url+"/charges/"+@payment_transaction.payment_code+'/cancel')

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["Content-Type"] = "application/json"
          request["x-api-version"] = "4.0"
          request["Authorization"] = @token
          request.body = values

          response = https.request(request)
          transaction = JSON.parse(response.read_body)
          return [true, '', transaction]

        rescue Exception => e
          return [false, e.message, nil]
        end
      end

    end
  end
end
