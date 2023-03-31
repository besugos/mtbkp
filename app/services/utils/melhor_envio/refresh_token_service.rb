module Utils
  module MelhorEnvio
    class RefreshTokenService < BaseService

      def initialize(refresh_token)
        @refresh_token = refresh_token
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        calculate_freight_values
      end

      private

      def invalid?
        service = Utils::MelhorEnvio::AccessService.new
        transaction = service.call
        transaction.nil? || @refresh_token.nil? || @refresh_token.blank?
      end

      def define_environment_data
        service = Utils::MelhorEnvio::AccessService.new
        transaction = service.call
        @url = transaction[0]
        @client_id = transaction[1]
        @client_secret = transaction[2]
        @token = transaction[3]
      end

      def calculate_freight_values
        begin

          url = URI(@url+"/oauth/token")

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["Accept"] = "application/json"
          request["User-Agent"] = "Aplicação servicos@sulivam.com.br"
          request["Content-Type"] = "application/json"
          form_data = [['grant_type', 'refresh_token'],['refresh_token', @refresh_token],['client_id', @client_id],['client_secret', @client_secret]]
          request.set_form form_data, 'multipart/form-data'

          response = https.request(request)
          transaction = JSON.parse(response.read_body)

          if Rails.env.development?
            Rails.logger.info transaction
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
