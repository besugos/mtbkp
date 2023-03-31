module Utils
  module PagSeguro
    module Pix
      class CheckPaymentService < BaseService

        # Exemplo
        # service = Utils::PagSeguro::Pix::CheckPaymentService.new(access_token, txid)
        # result = service.call
        def initialize(access_token, txid)
          @access_token = access_token
          @txid = txid
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
          (@txid.blank? || @txid.nil?) ||
          (@access_token.blank? || @access_token.nil?) ||
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
            url = URI(@url+"/instant-payments/cob/"+@txid+"?revisao=0")

            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            https.key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@key_name))
            https.cert = OpenSSL::X509::Certificate.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@cert_name))

            request = Net::HTTP::Get.new(url)
            request["Content-Type"] = "application/json"
            request["Authorization"] = "Bearer "+@access_token

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
#   "status": "CONCLUIDA",
#   "location": "api-h.pagseguro.com/pix/v2/D0112356-5197-4B42-AE63-CADD6628B360",
#   "calendario": {
#     "criacao": "2022-03-18T21:01:46Z",
#     "expiracao": 600
#   },
#   "txid": "g5d6n2xx1fhwhuzplhuul5q6fx1b0cdj",
#   "revisao": 0,
#   "devedor": {
#     "cpf": "09542817053",
#     "nome": "Comprador de teste"
#   },
#   "valor": {
#     "original": "13.44"
#   },
#   "chave": "g5d6n2xx1fhwhuzplhuul5q6fx1b0cdj",
#   "solicitacaoPagador": "Descrição do pagamento",
#   "pix": [
#     {
#       "endToEndId": "6a7a924dee164cbcbabfac1ac28d0015",
#       "txid": "g5d6n2xx1fhwhuzplhuul5q6fx1b0cdj",
#       "valor": "13.44",
#       "horario": "2022-03-18T21:01:49Z"
#     }
#   ],
#   "infoAdicionais": []
# }
