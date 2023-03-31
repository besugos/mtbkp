module Utils
  module MelhorEnvio
    class PrintService < BaseService

      ## Resultado
      def initialize(order_id)
        @order_id = order_id
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        print
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

      def print
        begin

          values = {
            mode: "private",
            orders: [
              @order_id
            ]
          }.to_json

          url = URI(@url+"/api/v2/me/shipment/print")

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["Accept"] = "application/json"
          request["Content-Type"] = "application/json"
          request["User-Agent"] = "Aplicação servicos@sulivam.com.br"
          request["Authorization"] = @token
          request.body = values
          response = https.request(request)
          
          begin
            transaction = JSON.parse(response.read_body)
            if Rails.env.development?
              Rails.logger.info transaction.to_json
            end
          rescue Exception => e
            Rails.logger.error e.message
            transaction = ""
          end
          
          return [true, '', transaction]

        rescue Exception => e
          Rails.logger.error "-- print --"
          Rails.logger.error e.message
          return [false, e.message, nil]
        end
      end

    end
  end
end
