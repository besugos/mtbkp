module Utils
  module PagSeguro
    module Order
      class CreateOrderService < BaseService

        # reference_id = "123456"
        
        # customer = {
        #   name: "Novo comprador",
        #   email: "email@email.com",
        #   tax_id: "90767156021"
        # }
        
        # items = [
        #   {
        #     reference_id: "referencia do item",
        #     name: "Nome do item",
        #     quantity: "1",
        #     unit_amount: "1"
        #   }
        # ]

        # qr_codes = [
        #   {
        #     amount: {
        #       value: 100
        #     }
        #   }
        # ]

        # shipping = {
        #     address: {
        #         street: "Avenida Brigadeiro Faria Lima",
        #         number: "1384",
        #         complement: "apto 12",
        #         locality: "Pinheiros",
        #         city: "São Paulo",
        #         region_code: "SP",
        #         country: "BRA",
        #         postal_code: "01452002"
        #     }
        # }

        # notification_urls = [
        #   "https://meusite.com/notificacoes"
        # ]
        
        # service = Utils::PagSeguro::Order::CreateOrderService.new(reference_id, customer, items, qr_codes, shipping, notification_urls)
        # transaction = service.call
        # Rails.logger.info transaction
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
end