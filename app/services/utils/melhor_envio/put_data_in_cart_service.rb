module Utils
  module MelhorEnvio
    class PutDataInCartService < BaseService

      ## from
      # {
      #   "name": "Nome do remetente",
      #   "phone": "53984470102",
      #   "email": "contato@melhorenvio.com.br",
      #   "document": "16571478358",
      #   "company_document": "89794131000100",
      #   "state_register": "123456",
      #   "address": "Endereço do remetente",
      #   "complement": "Complemento",
      #   "number": "1",
      #   "district": "Bairro",
      #   "city": "São Paulo",
      #   "country_id": "BR",
      #   "postal_code": "01002001",
      #   "note": "observação"
      # }
      
      ## to
      # {
      #   "name": "Nome do destinatário",
      #   "phone": "53984470102",
      #   "email": "contato@melhorenvio.com.br",
      #   "document": "25404918047",
      #   "company_document": "07595604000177",
      #   "state_register": "123456",
      #   "address": "Endereço do destinatário",
      #   "complement": "Complemento",
      #   "number": "2",
      #   "district": "Bairro",
      #   "city": "Porto Alegre",
      #   "state_abbr": "RS",
      #   "country_id": "BR",
      #   "postal_code": "90570020",
      #   "note": "observação"
      # }

      ## products
      # [
      #   {
      #     "name": "Papel adesivo para etiquetas 1",
      #     "quantity": 3,
      #     "unitary_value": 100.00
      #   },
      #   {
      #     "name": "Papel adesivo para etiquetas 2",
      #     "quantity": 1,
      #     "unitary_value": 700.00
      #   }
      # ]

      ## volumes
      # [
      #   {
      #     "height": 15,
      #     "width": 20,
      #     "length": 10,
      #     "weight": 3.5
      #   }
      # ]

      # RESULTADO
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
      def initialize(service_id, from, to, products, volumes, options)
        @service_id = service_id
        @from = from
        @to = to
        @products = products
        @volumes = volumes
        @options = options
      end

      def call
        return [false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        put_data_in_cart
      end

      private

      def invalid?
        service = Utils::MelhorEnvio::AccessService.new
        transaction = service.call
        (@service_id.nil? || @service_id.blank?) || 
        (@from.nil? || @from.blank?) || 
        (@to.nil? || @to.blank?) || 
        (@products.nil? || @products.blank?) || 
        (@volumes.nil? || @volumes.blank?) || transaction.nil?
      end

      def define_environment_data
        service = Utils::MelhorEnvio::AccessService.new
        transaction = service.call
        @url = transaction[0]
        @client_id = transaction[1]
        @client_secret = transaction[2]
        @token = transaction[3]
      end

      def put_data_in_cart
        begin

          if @options.nil? || @options.blank?
            @options = {
              non_commercial: true
            }
          end
          
          values = {
            service: @service_id,
            agency: 2,
            from: @from,
            to: @to,
            products: @products,
            volumes: @volumes,
            options: @options
          }.to_json

          url = URI(@url+"/api/v2/me/cart")

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
