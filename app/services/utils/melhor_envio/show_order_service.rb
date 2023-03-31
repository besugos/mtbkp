module Utils
  module MelhorEnvio
    class ShowOrderService < BaseService

      ## Resultado
      # {
      #   "id": "76343a9b-efd6-44dc-9584-59b0d0a48a26",
      #   "protocol": "ORD-202303122478",
      #   "service_id": 1,
      #   "agency_id": null,
      #   "contract": "9912415671",
      #   "service_code": null,
      #   "quote": 30.79,
      #   "price": 30.79,
      #   "coupon": null,
      #   "discount": 3.91,
      #   "delivery_min": 6,
      #   "delivery_max": 7,
      #   "status": "pending",
      #   "reminder": null,
      #   "insurance_value": 0,
      #   "weight": null,
      #   "width": null,
      #   "height": null,
      #   "length": null,
      #   "diameter": null,
      #   "format": "box",
      #   "billed_weight": 3.5,
      #   "receipt": false,
      #   "own_hand": false,
      #   "collect": false,
      #   "collect_scheduled_at": null,
      #   "reverse": false,
      #   "non_commercial": false,
      #   "authorization_code": null,
      #   "tracking": null,
      #   "self_tracking": null,
      #   "delivery_receipt": null,
      #   "additional_info": null,
      #   "cte_key": null,
      #   "paid_at": null,
      #   "generated_at": null,
      #   "posted_at": null,
      #   "delivered_at": null,
      #   "canceled_at": null,
      #   "suspended_at": null,
      #   "expired_at": null,
      #   "created_at": "2023-03-08 01:02:20",
      #   "updated_at": "2023-03-08 01:02:20",
      #   "parse_pi_at": null,
      #   "from": {
      #     "name": "Nome do remetente",
      #     "phone": "53984470102",
      #     "email": "contato@melhorenvio.com.br",
      #     "document": "16571478358",
      #     "company_document": "89794131000100",
      #     "state_register": "123456",
      #     "postal_code": "1002001",
      #     "address": "Endereço do remetente",
      #     "location_number": "1",
      #     "complement": "Complemento",
      #     "district": "Bairro",
      #     "city": "São Paulo",
      #     "state_abbr": "SP",
      #     "country_id": "BR",
      #     "latitude": null,
      #     "longitude": null,
      #     "note": "observação"
      #   },
      #   "to": {
      #     "name": "Nome do destinatário",
      #     "phone": "53984470102",
      #     "email": "contato@melhorenvio.com.br",
      #     "document": "25404918047",
      #     "company_document": "07595604000177",
      #     "state_register": "123456",
      #     "postal_code": "90570020",
      #     "address": "Endereço do destinatário",
      #     "location_number": "2",
      #     "complement": "Complemento",
      #     "district": "Bairro",
      #     "city": "Porto Alegre",
      #     "state_abbr": "RS",
      #     "country_id": "BR",
      #     "latitude": null,
      #     "longitude": null,
      #     "note": "observação"
      #   },
      #   "service": {
      #     "id": 1,
      #     "name": "PAC",
      #     "status": "available",
      #     "type": "normal",
      #     "range": "interstate",
      #     "restrictions": "{\"insurance_value\":{\"min\":0,\"max\":3000},\"formats\":{\"box\":{\"weight\":{\"min\":0.001,\"max\":30},\"width\":{\"min\":11,\"max\":105},\"height\":{\"min\":2,\"max\":105},\"length\":{\"min\":16,\"max\":105},\"sum\":200},\"roll\":{\"weight\":{\"min\":0.001,\"max\":30},\"diameter\":{\"min\":5,\"max\":91},\"length\":{\"min\":18,\"max\":105},\"sum\":200},\"letter\":{\"weight\":{\"min\":0.001,\"max\":0.5},\"width\":{\"min\":11,\"max\":60},\"length\":{\"min\":16,\"max\":60}}}}",
      #     "requirements": "[\"names\",\"addresses\"]",
      #     "optionals": "[\"AR\",\"MP\",\"VD\"]",
      #     "company": {
      #       "id": 1,
      #       "name": "Correios",
      #       "status": "available",
      #       "picture": "/images/shipping-companies/correios.png",
      #       "use_own_contract": false
      #     }
      #   },
      #   "agency": null,
      #   "invoice": null,
      #   "tags": [],
      #   "products": [
      #     {
      #       "name": "Papel adesivo para etiquetas 1",
      #       "quantity": 3,
      #       "unitary_value": 100,
      #       "weight": null
      #     },
      #     {
      #       "name": "Papel adesivo para etiquetas 2",
      #       "quantity": 1,
      #       "unitary_value": 700,
      #       "weight": null
      #     }
      #   ],
      #   "generated_key": null,
      #   "volumes": [
      #     {
      #       "id": 126970,
      #       "height": "10.00",
      #       "width": "15.00",
      #       "length": "20.00",
      #       "diameter": "0.00",
      #       "weight": "3.50",
      #       "format": "box",
      #       "created_at": "2023-03-08 01:02:20",
      #       "updated_at": "2023-03-08 01:02:20"
      #     }
      #   ]
      # }
      def initialize(order_id)
        @order_id = order_id
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        show_order
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

      def show_order
        begin

          url = URI(@url+"/api/v2/me/orders/"+@order_id)

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Get.new(url)
          request["Accept"] = "application/json"
          request["Content-Type"] = "application/json"
          request["User-Agent"] = "Aplicação servicos@sulivam.com.br"
          request["Authorization"] = @token

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
