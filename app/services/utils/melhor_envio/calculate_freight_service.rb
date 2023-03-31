module Utils
  module MelhorEnvio
    class CalculateFreightService < BaseService

      ## products_formatted
      # [
      #   {
      #     "id": "x",
      #     "width": 11,
      #     "height": 17,
      #     "length": 11,
      #     "weight": 0.3,
      #     "quantity": 1
      #   },
      #   {
      #     "id": "y",
      #     "width": 16,
      #     "height": 25,
      #     "length": 11,
      #     "weight": 0.3,
      #     "insurance_value": 55.05,
      #     "quantity": 2
      #   },
      #   {
      #     "id": "z",
      #     "width": 22,
      #     "height": 30,
      #     "length": 11,
      #     "weight": 1,
      #     "insurance_value": 30,
      #     "quantity": 1
      #   }
      # ]

      # RESULTADO
      # [
      #   {
      #     "id": 1,
      #     "name": "PAC",
      #     "price": "28.38",
      #     "custom_price": "28.38",
      #     "discount": "4.55",
      #     "currency": "R$",
      #     "delivery_time": 8,
      #     "delivery_range": {
      #       "min": 7,
      #       "max": 8
      #     },
      #     "custom_delivery_time": 8,
      #     "custom_delivery_range": {
      #       "min": 7,
      #       "max": 8
      #     },
      #     "packages": [
      #       {
      #         "price": "28.38",
      #         "discount": "4.55",
      #         "format": "box",
      #         "dimensions": {
      #           "height": 21,
      #           "width": 30,
      #           "length": 30
      #         },
      #         "weight": "1.90",
      #         "insurance_value": "140.10",
      #         "products": [
      #           {
      #             "id": "x",
      #             "quantity": 1
      #           },
      #           {
      #             "id": "y",
      #             "quantity": 2
      #           },
      #           {
      #             "id": "z",
      #             "quantity": 1
      #           }
      #         ]
      #       }
      #     ],
      #     "additional_services": {
      #       "receipt": false,
      #       "own_hand": false,
      #       "collect": false
      #     },
      #     "company": {
      #       "id": 1,
      #       "name": "Correios",
      #       "picture": "http://sandbox.melhorenvio.com.br/images/shipping-companies/correios.png"
      #     }
      #   },
      #   {
      #     "id": 2,
      #     "name": "SEDEX",
      #     "price": "54.30",
      #     "custom_price": "54.30",
      #     "discount": "12.13",
      #     "currency": "R$",
      #     "delivery_time": 4,
      #     "delivery_range": {
      #       "min": 3,
      #       "max": 4
      #     },
      #     "custom_delivery_time": 4,
      #     "custom_delivery_range": {
      #       "min": 3,
      #       "max": 4
      #     },
      #     "packages": [
      #       {
      #         "price": "54.30",
      #         "discount": "12.13",
      #         "format": "box",
      #         "dimensions": {
      #           "height": 21,
      #           "width": 30,
      #           "length": 30
      #         },
      #         "weight": "1.90",
      #         "insurance_value": "140.10",
      #         "products": [
      #           {
      #             "id": "x",
      #             "quantity": 1
      #           },
      #           {
      #             "id": "y",
      #             "quantity": 2
      #           },
      #           {
      #             "id": "z",
      #             "quantity": 1
      #           }
      #         ]
      #       }
      #     ],
      #     "additional_services": {
      #       "receipt": false,
      #       "own_hand": false,
      #       "collect": false
      #     },
      #     "company": {
      #       "id": 1,
      #       "name": "Correios",
      #       "picture": "http://sandbox.melhorenvio.com.br/images/shipping-companies/correios.png"
      #     }
      #   },
      #   {
      #     "id": 3,
      #     "name": ".Package",
      #     "price": "36.40",
      #     "custom_price": "36.40",
      #     "discount": "27.29",
      #     "currency": "R$",
      #     "delivery_time": 6,
      #     "delivery_range": {
      #       "min": 5,
      #       "max": 6
      #     },
      #     "custom_delivery_time": 6,
      #     "custom_delivery_range": {
      #       "min": 5,
      #       "max": 6
      #     },
      #     "packages": [
      #       {
      #         "format": "box",
      #         "dimensions": {
      #           "height": 21,
      #           "width": 30,
      #           "length": 30
      #         },
      #         "weight": "1.90",
      #         "insurance_value": "140.10",
      #         "products": [
      #           {
      #             "id": "x",
      #             "quantity": 1
      #           },
      #           {
      #             "id": "y",
      #             "quantity": 2
      #           },
      #           {
      #             "id": "z",
      #             "quantity": 1
      #           }
      #         ]
      #       }
      #     ],
      #     "additional_services": {
      #       "receipt": false,
      #       "own_hand": false,
      #       "collect": false
      #     },
      #     "company": {
      #       "id": 2,
      #       "name": "Jadlog",
      #       "picture": "http://sandbox.melhorenvio.com.br/images/shipping-companies/jadlog.png"
      #     }
      #   },
      #   {
      #     "id": 4,
      #     "name": ".Com",
      #     "price": "41.62",
      #     "custom_price": "41.62",
      #     "discount": "56.08",
      #     "currency": "R$",
      #     "delivery_time": 5,
      #     "delivery_range": {
      #       "min": 4,
      #       "max": 5
      #     },
      #     "custom_delivery_time": 5,
      #     "custom_delivery_range": {
      #       "min": 4,
      #       "max": 5
      #     },
      #     "packages": [
      #       {
      #         "format": "box",
      #         "dimensions": {
      #           "height": 21,
      #           "width": 30,
      #           "length": 30
      #         },
      #         "weight": "1.90",
      #         "insurance_value": "140.10",
      #         "products": [
      #           {
      #             "id": "x",
      #             "quantity": 1
      #           },
      #           {
      #             "id": "y",
      #             "quantity": 2
      #           },
      #           {
      #             "id": "z",
      #             "quantity": 1
      #           }
      #         ]
      #       }
      #     ],
      #     "additional_services": {
      #       "receipt": false,
      #       "own_hand": false,
      #       "collect": false
      #     },
      #     "company": {
      #       "id": 2,
      #       "name": "Jadlog",
      #       "picture": "http://sandbox.melhorenvio.com.br/images/shipping-companies/jadlog.png"
      #     }
      #   },
      #   {
      #     "id": 17,
      #     "name": "Mini Envios",
      #     "error": "Dimensões do objeto ultrapassam o limite da transportadora.",
      #     "company": {
      #       "id": 1,
      #       "name": "Correios",
      #       "picture": "http://sandbox.melhorenvio.com.br/images/shipping-companies/correios.png"
      #     }
      #   }
      # ]
      def initialize(postalcode_from, postalcode_to, products_formatted)
        @postalcode_from = postalcode_from
        @postalcode_to = postalcode_to
        @products_formatted = products_formatted
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
        (@postalcode_from.nil? || @postalcode_from.blank?) || 
        (@postalcode_to.nil? || @postalcode_to.blank?) || 
        (@products_formatted.nil? || @products_formatted.length == 0) || 
        transaction.nil?
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

          values = {
            from: {
              postal_code: @postalcode_from
            },
            to: {
              postal_code: @postalcode_to
            },
            products: @products_formatted
          }.to_json

          url = URI(@url+"/api/v2/me/shipment/calculate")

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
