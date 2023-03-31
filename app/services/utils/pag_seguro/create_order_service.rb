module Utils
  module PagSeguro
    class CreateOrderService < BaseService

      def initialize(reference_id, customer, items, qr_codes, shipping, notification_urls)
        @reference_id = reference_id
        @customer = customer
        @items = items
        @qr_codes = qr_codes
        @shipping = shipping
        @notification_urls = notification_urls
      end

      def call
        return [false, false, I18n.t("session.invalid_data")] if invalid?
        define_environment_data
        execute_function
      end

      private

      def invalid?
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        (@reference_id.blank? || @reference_id.nil?) ||
        (@customer.blank? || @customer.nil?) ||
        (@items.blank? || @items.nil?) ||
        (@qr_codes.blank? || @qr_codes.nil?) ||
        transaction.nil?
      end

      def define_environment_data
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        @url = transaction[0]
        @token = transaction[1]
      end

      def execute_function
        begin
          url = URI(@url+"/orders")

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          @customer[:name] = @customer[:name].match('[A-Za-z áàâãéèêíïóôõöúçñÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ]+')[0]
          @customer[:tax_id] = @customer[:tax_id].gsub(".","").gsub("-","")

          values = {
            reference_id: @reference_id,
            customer: @customer,
            items: @items,
            qr_codes: @qr_codes,
            shipping: @shipping,
            notification_urls: @notification_urls
          }.to_json

          request = Net::HTTP::Post.new(url)
          request["Content-Type"] = "application/json"
          request["Authorization"] = @token
          request.body = values

          response = https.request(request)
          transaction = JSON.parse(response.read_body)
          
          return [true, transaction]
        rescue Exception => e
          Rails.logger.error e.message
          return [false, false, e.message]
        end
      end

    end
  end
end