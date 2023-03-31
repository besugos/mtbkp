module Utils
  module MelhorEnvio
    class CheckoutService < BaseService

      ## Resultado
      # {
      #   "purchase": {
      #     "id": "6447bd84-de1b-47ec-96b6-46ff6ac0bdc0",
      #     "protocol": "PUR-20230334570",
      #     "total": 30.79,
      #     "discount": 3.91,
      #     "status": "paid",
      #     "paid_at": "2023-03-08 01:23:27",
      #     "canceled_at": null,
      #     "created_at": "2023-03-08 01:23:27",
      #     "updated_at": "2023-03-08 01:23:27",
      #     "payment": null,
      #     "transactions": [
      #       {
      #         "id": "c6d43154-4366-4d42-8754-a22dbb3baa8d",
      #         "protocol": "TRN-20230373536",
      #         "value": 30.79,
      #         "type": "debit",
      #         "status": "authorized",
      #         "description": "Pagamento de envios (PUR-20230334570)",
      #         "authorized_at": "2023-03-08 01:23:27",
      #         "unauthorized_at": null,
      #         "reserved_at": null,
      #         "canceled_at": null,
      #         "created_at": "2023-03-08 01:23:27",
      #         "description_internal": null,
      #         "reason": {
      #           "id": 7,
      #           "label": "Pagamento de envios",
      #           "description": ""
      #         }
      #       }
      #     ],
      #     "orders": [
      #       {
      #         "id": "76343a9b-efd6-44dc-9584-59b0d0a48a26",
      #         "protocol": "ORD-202303122478",
      #         "service_id": 1,
      #         "agency_id": null,
      #         "contract": "9912415671",
      #         "service_code": null,
      #         "quote": 30.79,
      #         "price": 30.79,
      #         "coupon": null,
      #         "discount": 3.91,
      #         "delivery_min": 6,
      #         "delivery_max": 7,
      #         "status": "released",
      #         "reminder": null,
      #         "insurance_value": 0,
      #         "weight": null,
      #         "width": null,
      #         "height": null,
      #         "length": null,
      #         "diameter": null,
      #         "format": "box",
      #         "billed_weight": 3.5,
      #         "receipt": false,
      #         "own_hand": false,
      #         "collect": false,
      #         "collect_scheduled_at": null,
      #         "reverse": false,
      #         "non_commercial": false,
      #         "authorization_code": null,
      #         "tracking": null,
      #         "self_tracking": null,
      #         "delivery_receipt": null,
      #         "additional_info": null,
      #         "cte_key": null,
      #         "paid_at": "2023-03-08 01:23:27",
      #         "generated_at": null,
      #         "posted_at": null,
      #         "delivered_at": null,
      #         "canceled_at": null,
      #         "suspended_at": null,
      #         "expired_at": null,
      #         "created_at": "2023-03-08 01:02:20",
      #         "updated_at": "2023-03-08 01:23:27",
      #         "parse_pi_at": null,
      #         "from": {
      #           "name": "Nome do remetente",
      #           "phone": "53984470102",
      #           "email": "contato@melhorenvio.com.br",
      #           "document": "16571478358",
      #           "company_document": "89794131000100",
      #           "state_register": "123456",
      #           "postal_code": "1002001",
      #           "address": "Endereço do remetente",
      #           "location_number": "1",
      #           "complement": "Complemento",
      #           "district": "Bairro",
      #           "city": "São Paulo",
      #           "state_abbr": "SP",
      #           "country_id": "BR",
      #           "latitude": null,
      #           "longitude": null,
      #           "note": "observação"
      #         },
      #         "to": {
      #           "name": "Nome do destinatário",
      #           "phone": "53984470102",
      #           "email": "contato@melhorenvio.com.br",
      #           "document": "25404918047",
      #           "company_document": "07595604000177",
      #           "state_register": "123456",
      #           "postal_code": "90570020",
      #           "address": "Endereço do destinatário",
      #           "location_number": "2",
      #           "complement": "Complemento",
      #           "district": "Bairro",
      #           "city": "Porto Alegre",
      #           "state_abbr": "RS",
      #           "country_id": "BR",
      #           "latitude": null,
      #           "longitude": null,
      #           "note": "observação"
      #         },
      #         "service": {
      #           "id": 1,
      #           "name": "PAC",
      #           "status": "available",
      #           "type": "normal",
      #           "range": "interstate",
      #           "restrictions": "{\"insurance_value\":{\"min\":0,\"max\":3000},\"formats\":{\"box\":{\"weight\":{\"min\":0.001,\"max\":30},\"width\":{\"min\":11,\"max\":105},\"height\":{\"min\":2,\"max\":105},\"length\":{\"min\":16,\"max\":105},\"sum\":200},\"roll\":{\"weight\":{\"min\":0.001,\"max\":30},\"diameter\":{\"min\":5,\"max\":91},\"length\":{\"min\":18,\"max\":105},\"sum\":200},\"letter\":{\"weight\":{\"min\":0.001,\"max\":0.5},\"width\":{\"min\":11,\"max\":60},\"length\":{\"min\":16,\"max\":60}}}}",
      #           "requirements": "[\"names\",\"addresses\"]",
      #           "optionals": "[\"AR\",\"MP\",\"VD\"]",
      #           "company": {
      #             "id": 1,
      #             "name": "Correios",
      #             "status": "available",
      #             "picture": "/images/shipping-companies/correios.png",
      #             "use_own_contract": false
      #           }
      #         },
      #         "agency": null,
      #         "invoice": null,
      #         "tags": [],
      #         "products": [
      #           {
      #             "name": "Papel adesivo para etiquetas 1",
      #             "quantity": 3,
      #             "unitary_value": 100,
      #             "weight": null
      #           },
      #           {
      #             "name": "Papel adesivo para etiquetas 2",
      #             "quantity": 1,
      #             "unitary_value": 700,
      #             "weight": null
      #           }
      #         ],
      #         "generated_key": null
      #       }
      #     ],
      #     "paypal_discounts": []
      #   },
      #   "conciliation_group": {
      #     "id": "ae96658f-8770-430a-88b2-09dcbc05f0ea",
      #     "protocol": "CGP-20230311833",
      #     "total": 19,
      #     "type": "debit",
      #     "status": "paid",
      #     "paid_at": "2023-03-08 01:23:27",
      #     "canceled_at": null,
      #     "created_at": "2023-03-08 01:23:27",
      #     "updated_at": "2023-03-08 01:23:27",
      #     "conciliations": [
      #       {
      #         "status": "paid",
      #         "service_code": null,
      #         "from_postal_code": "1002001",
      #         "from_city": "São Paulo",
      #         "from_state_abbr": "SP",
      #         "to_postal_code": "90570020",
      #         "to_city": "Porto Alegre",
      #         "to_state_abbr": "RS",
      #         "authorization_code": "2023030104",
      #         "tracking": "ME23002MBZ7BR",
      #         "quote": 61.23,
      #         "price": 61.23,
      #         "discount": 31,
      #         "value": 19,
      #         "type": "debit",
      #         "insurance_value": 1000,
      #         "weight": null,
      #         "width": null,
      #         "height": null,
      #         "length": null,
      #         "diameter": null,
      #         "format": "box",
      #         "billed_weight": 3.5,
      #         "receipt": false,
      #         "own_hand": false,
      #         "collect": false,
      #         "distinct_metrics": true,
      #         "paid_at": "2023-03-08 01:23:27",
      #         "canceled_at": null,
      #         "created_at": "2023-03-01 05:15:06",
      #         "updated_at": "2023-03-08 01:23:27",
      #         "rate": null,
      #         "user": {
      #           "id": "94cc550e-a4c8-4beb-a3eb-0ace7f54b01b",
      #           "protocol": 373,
      #           "firstname": "André",
      #           "lastname": "Sulivam",
      #           "email": "andre.sulivam@harmis.com.br",
      #           "picture": null,
      #           "thumbnail": null,
      #           "document": "10205815650",
      #           "birthdate": "1990-09-26 00:00:00",
      #           "email_confirmed_at": "2019-10-30 19:20:30",
      #           "email_alternative": null,
      #           "access_at": "2023-03-07 17:53:37",
      #           "created_at": "2019-10-30 19:20:30",
      #           "updated_at": "2019-10-30 19:20:40"
      #         },
      #         "group": {
      #           "id": "ae96658f-8770-430a-88b2-09dcbc05f0ea",
      #           "protocol": "CGP-20230311833",
      #           "total": 19,
      #           "type": "debit",
      #           "status": "paid",
      #           "paid_at": "2023-03-08 01:23:27",
      #           "canceled_at": null,
      #           "created_at": "2023-03-08 01:23:27",
      #           "updated_at": "2023-03-08 01:23:27"
      #         },
      #         "agency": null
      #       }
      #     ],
      #     "transactions": [
      #       {
      #         "id": "a3f8f189-9246-4804-a51a-d3c2f07e8926",
      #         "protocol": "TRN-20230373535",
      #         "value": 19,
      #         "type": "debit",
      #         "status": "authorized",
      #         "description": "Pagamento de pendências via conferência de postagens (CGP-20230311833)",
      #         "authorized_at": "2023-03-08 01:23:27",
      #         "unauthorized_at": null,
      #         "reserved_at": null,
      #         "canceled_at": null,
      #         "created_at": "2023-03-08 01:23:27",
      #         "description_internal": null,
      #         "reason": {
      #           "id": 8,
      #           "label": "Pagamento de pendência via conferência de postagens",
      #           "description": ""
      #         }
      #       }
      #     ],
      #     "payment": null
      #   },
      #   "digitable": null,
      #   "redirect": null,
      #   "message": null,
      #   "token": null,
      #   "payment_id": null
      # }
      def initialize(order_id)
        @order_id = order_id
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        checkout
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

      def checkout
        begin

          values = {
            orders: [
              @order_id
            ]
          }.to_json

          url = URI(@url+"/api/v2/me/shipment/checkout")

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
