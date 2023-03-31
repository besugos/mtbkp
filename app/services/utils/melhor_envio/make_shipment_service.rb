module Utils
  module MelhorEnvio
    class MakeShipmentService < BaseService

      ## Resultado
      # {
      #   "76343a9b-efd6-44dc-9584-59b0d0a48a26": {
      #     "status": true,
      #     "message": "Envio gerado com sucesso"
      #   }
      # }
      def initialize(order_id)
        @order_id = order_id
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        make_shipment
      end

      private

      def invalid?
        service = Utils::MelhorEnvio::AccessService.new
        transaction = service.call
        (@order_id.nil? || @order_id.blank?)|| transaction.nil?
      end

      def define_environment_data
        service = Utils::MelhorEnvio::AccessService.new
        transaction = service.call
        @url = transaction[0]
        @client_id = transaction[1]
        @client_secret = transaction[2]
        @token = transaction[3]
      end

      def make_shipment
        begin

          values = {
            orders: [
              @order_id
            ]
          }.to_json

          url = URI(@url+"/api/v2/me/shipment/generate")

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["Accept"] = "application/json"
          request["Content-Type"] = "application/json"
          request["User-Agent"] = "Aplicação servicos@sulivam.com.br"
          request["Authorization"] = @token
          request.body = values

          response = https.request(request)
          transaction = JSON.parse(response.read_body)

          if Rails.env.development?
            Rails.logger.info transaction.to_json
          end
          
          return [true, '', transaction]

        rescue Exception => e
          Rails.logger.error e.message
          return [false, e.message, nil]
        end
      end

    end
  end
end
