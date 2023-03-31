module Utils
  module MelhorEnvio
    class TrackOrderService < BaseService

      ## Resultado
      # {
      #   "76343a9b-efd6-44dc-9584-59b0d0a48a26": {
      #     "id": "76343a9b-efd6-44dc-9584-59b0d0a48a26",
      #     "protocol": "ORD-202303122478",
      #     "status": "released",
      #     "tracking": "ME23002MI63BR",
      #     "melhorenvio_tracking": "ME23002MI63BR",
      #     "created_at": "2023-03-08 01:02:20",
      #     "paid_at": "2023-03-08 01:23:27",
      #     "generated_at": "2023-03-08 01:26:56",
      #     "posted_at": null,
      #     "delivered_at": null,
      #     "canceled_at": null,
      #     "expired_at": null
      #   }
      # }
      def initialize(order_id)
        @order_id = order_id
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        track_order
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

      def track_order
        begin

          values = {
            orders: [
              @order_id
            ]
          }.to_json

          url = URI(@url+"/api/v2/me/shipment/tracking")

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
