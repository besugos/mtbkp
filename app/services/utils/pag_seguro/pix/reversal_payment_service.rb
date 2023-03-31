module Utils
  module PagSeguro
    module Pix
      class ReversalPaymentService < BaseService

        # Exemplo
        # service = Utils::PagSeguro::Pix::ReversalPaymentService.new(access_token, end_to_end_id, reversal_id)
        # result = service.call
        def initialize(access_token, end_to_end_id, reversal_id, value)
          @access_token = access_token
          @end_to_end_id = end_to_end_id
          @reversal_id = reversal_id
          @value = value
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
          (@end_to_end_id.blank? || @end_to_end_id.nil?) ||
          (@access_token.blank? || @access_token.nil?) ||
          (@reversal_id.blank? || @reversal_id.nil?) ||
          (@value.blank? || @value.nil?) ||
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
          @token = transaction[5]
          @url_general = transaction[6]
        end

        def execute_function
          begin
            url = URI(@url+"/instant-payments/pix/"+@end_to_end_id+"/devolucao/"+@reversal_id)

            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            https.key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@key_name))
            https.cert = OpenSSL::X509::Certificate.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@cert_name))

            values = {
              valor: @value 
            }.to_json

            request = Net::HTTP::Put.new(url)
            request["Content-Type"] = "application/json"
            request["Authorization"] = "Bearer "+@access_token
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
#   "id": "123456344",
#   "rtrId": "D08561701202203182101TZIL9LRNS1T",
#   "valor": "13.44",
#   "horario": {
#     "solicitacao": "2022-03-18T21:01:54.202775Z"
#   },
#   "status": "EM_PROCESSAMENTO"
# }