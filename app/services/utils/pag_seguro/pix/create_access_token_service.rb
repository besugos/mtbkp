module Utils
  module PagSeguro
    module Pix
      class CreateAccessTokenService < BaseService

        # Exemplo
        # scope = "cob.write cob.read pix.write pix.read webhook.write webhook.read payloadlocation.write payloadlocation.read"
        # service = Utils::PagSeguro::Pix::CreateAccessTokenService.new(scope)
        # result = service.call
        def initialize(scope)
          @scope = scope
        end

        def call
          return [false, false, I18n.t("session.invalid_data")] if invalid?
          define_environment_data
          execute_function
        end

        private

        def invalid?
          service = Utils::PagSeguro::Pix::AuthTokenService.new
          transaction = service.call
          (@scope.blank? || @scope.nil?) ||
          transaction.nil?
        end

        def define_environment_data
          service = Utils::PagSeguro::Pix::AuthTokenService.new
          transaction = service.call
          @url = transaction[0]
          @cert_name = transaction[1]
          @key_name = transaction[2]
          @client_id = transaction[3]
          @client_secret = transaction[4]
        end

        def execute_function
          begin
            url = URI(@url+"/pix/oauth2")

            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            https.key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@key_name))
            https.cert = OpenSSL::X509::Certificate.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@cert_name))

            values = {
              grant_type: "client_credentials",
              scope: @scope
            }.to_json

            request = Net::HTTP::Post.new(url)
            request["Content-Type"] = "application/json"
            request.basic_auth @client_id, @client_secret
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

# Exemplo
# {
#   "access_token": "dc1f0f4b-a8bf-4d6b-963f-33baa2b7e7b8637a584349f8af4ce0efe85af0d0e9cd3db4-b66e-47a8-95d3-113ba5480ac5",
#   "token_type": "Bearer",
#   "expires_in": 31536000,
#   "refresh_token": "acefa744-c3db-447d-9fbf-b9f2cb8c8e480a22661b456ebc2102d88141700ff9bfba12-7b21-474a-b4f8-37cf5fa6b8b2",
#   "scope": "cob.read cob.write payloadlocation.read payloadlocation.write pix.read pix.write webhook.read webhook.write"
# }