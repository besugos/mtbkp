module Utils
  module PagSeguro
    module Pix
      class CreatePaymentService < BaseService

        # Exemplo
        # txid = rand(36**32).to_s(36)
        # expiration_time = 600
        # document_buyer = "095.428.170-53"
        # name_buyer = "Comprador de teste"
        # value = "13.44"
        # description = "Descrição do pagamento"
        # info_adicionais = [
        #   {
        #     nome: "Adicional 1",
        #     valor: "Valor adicional 1"
        #   },
        #   {
        #     nome: "Adicional 2",
        #     valor: "Valor adicional 2"
        #   },
        # ]
        # service = Utils::PagSeguro::Pix::CreatePaymentService.new(access_token, txid, expiration_time, document_buyer, name_buyer, value, description, info_adicionais, chave)
        # result = service.call
        def initialize(access_token, txid, expiration_time, document_buyer, name_buyer, value, description, info_adicionais, chave)
          @access_token = access_token
          @txid = txid
          @expiration_time = expiration_time
          @document_buyer = document_buyer
          @name_buyer = name_buyer
          @value = value
          @description = description
          @chave = chave
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
          (@access_token.blank? || @access_token.nil?) ||
          (@txid.blank? || @txid.nil?) ||
          (@expiration_time.blank? || @expiration_time.nil?) ||
          (@document_buyer.blank? || @document_buyer.nil?) ||
          (@name_buyer.blank? || @name_buyer.nil?) ||
          (@value.blank? || @value.nil?) ||
          (@description.blank? || @description.nil?) ||
          (@chave.blank? || @chave.nil?) ||
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
            url = URI(@url+"/instant-payments/cob/"+@txid)

            @document_buyer = @document_buyer.gsub(".","")
            @document_buyer = @document_buyer.gsub("-","")
            @document_buyer = @document_buyer.gsub(" ","")

            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            https.key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@key_name))
            https.cert = OpenSSL::X509::Certificate.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@cert_name))

            values = {
              calendario: {
                expiracao: @expiration_time
              },
              devedor: {
                cpf: @document_buyer,
                nome: @name_buyer
              },
              valor: {
                original: @value
              },
              solicitacaoPagador: @description,
              chave: @chave,
              info_adicionais: @info_adicionais
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
#   "status": "ATIVA",
#   "calendario": {
#     "expiracao": 600,
#     "criacao": "2022-03-18T21:01:46Z"
#   },
#   "location": "api-h.pagseguro.com/pix/v2/D0112356-5197-4B42-AE63-CADD6628B360",
#   "txid": "g5d6n2xx1fhwhuzplhuul5q6fx1b0cdj",
#   "revisao": 0,
#   "devedor": {
#     "cpf": "09542817053",
#     "nome": "Comprador de teste"
#   },
#   "loc": {
#     "id": 9108616809554344000,
#     "location": "api-h.pagseguro.com/pix/v2/D0112356-5197-4B42-AE63-CADD6628B360",
#     "tipoCob": "COB",
#     "criacao": "2022-03-18T21:01:46Z"
#   },
#   "valor": {
#     "original": "13.44"
#   },
#   "chave": "g5d6n2xx1fhwhuzplhuul5q6fx1b0cdj",
#   "solicitacaoPagador": "Descrição do pagamento"
# }