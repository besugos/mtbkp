module Utils
  module PagSeguro
    module Pix
      class MakeSimulationPaymentService < BaseService

        # Exemplo
        # service = Utils::PagSeguro::Pix::MakeSimulationPaymentService.new(txid)
        # result = service.call
        def initialize(txid)
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
            url = URI(@url_general+"/pix/pay/"+@txid)

            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            https.key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@key_name))
            https.cert = OpenSSL::X509::Certificate.new(File.read("#{Rails.root}/app/services/utils/pag_seguro/pix/"+@cert_name))

            values = {
              status: "PAID",
              tx_id: @txid
            }.to_json

            request = Net::HTTP::Post.new(url)
            request["Content-Type"] = "application/json"
            request["Authorization"] = "Bearer "+@token
            request.body = values

            response = https.request(request)
            transaction = response.read_body

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
# ""