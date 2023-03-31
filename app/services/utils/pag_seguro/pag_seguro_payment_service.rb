module Utils
  module PagSeguro
    class PagSeguroPaymentService < BaseService

      def initialize(order, reference_id, description, value, payment_type, installments, card, payer, due_date)
        @order = order
        @reference_id = reference_id
        @description = description
        @value = value
        @payment_type = payment_type
        @installments = installments
        @card = card
        @payer = payer
        @due_date = due_date
      end

      def call
        return [false, false, I18n.t("session.invalid_data"), nil] if invalid?
        define_environment_data
        make_payment
      end

      private

      def invalid?
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        (@order.blank? || @order.nil?) ||
        (@payer.blank? || @payer.nil?) ||
        (@reference_id.blank? || @reference_id.nil?) ||
        (@description.blank? || @description.nil?) ||
        (@value.blank? || @value.nil?) ||
        (@payment_type.blank? || @payment_type.nil?) ||
        (@installments.blank? || @installments.nil?) ||
        ((@due_date.blank? || @due_date.nil?) && @payment_type == PaymentType::BOLETO_ID) ||
        ((@card.blank? || @card.nil?) && @payment_type == PaymentType::CARTAO_CREDITO_ID && @order.get_total_price > 0) ||
        transaction.nil?
      end

      def define_environment_data
        service = Utils::PagSeguro::PagSeguroAccessService.new
        transaction = service.call
        @url = transaction[0]
        @token = transaction[1]
      end

      def make_payment
        if @payment_type == PaymentType::CARTAO_CREDITO_ID
          make_payment_credit_card_order
        elsif @payment_type == PaymentType::BOLETO_ID
          make_payment_invoice
        elsif @payment_type == PaymentType::PIX_ID
          make_payment_pix
        end
      end

      def make_payment_credit_card_order
        begin
          correct_number = ""
          if !@card.nil?
            correct_number = @card.number.gsub(' ','')
          end

          if Rails.env.production?
            capture = true
          elsif Rails.env.development?
            capture = false
          end

          url_helper = Rails.application.routes.url_helpers

          if Rails.env.production?
            notification_url = url_helper.notify_change_payment_url
          else
            notification_url = ENV['HOST']+'notify_change_payment'
          end

          correct_price = @value
          if @order.get_total_price == 0
            create_valid_payment_transaction("")
          else
            values_charge = {
              reference_id: @reference_id,
              description: @description,
              amount: {
                value: (@value * 100).to_i,
                currency: "BRL"
              },
              payment_method: {
                type: "CREDIT_CARD",
                installments: @installments,
                capture: capture,
                card: {
                  number: correct_number,
                  exp_month: @card.validate_date_month,
                  exp_year: @card.validate_date_year,
                  security_code: @card.ccv_code,
                  holder: {
                    name: @card.name
                  }
                }
              }
            }

            values = {
              reference_id: @reference_id,
              customer: {
                name: @payer.name,
                email: @payer.email,
                tax_id: @payer.get_document_clean
              },
              items: [
                {
                  reference_id: @order.id.to_s,
                  name: "Pedido: "+@order.id.to_s,
                  quantity: 1,
                  unit_amount: (correct_price * 100).to_i
                }
              ],
              charges: [
                values_charge
              ],
              notification_urls: [
                notification_url
              ]
            }.to_json

            url = URI(@url+"/orders")

            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true

            request = Net::HTTP::Post.new(url)
            request["Content-Type"] = "application/json"
            request["x-api-version"] = "4.0"
            request["Authorization"] = @token
            request.body = values

            response = https.request(request)
            transaction = JSON.parse(response.read_body)

            if Rails.env.development?
              Rails.logger.info "-- make_payment_credit_card transaction --"
              Rails.logger.info transaction
            end

            if transaction["message"] != "Unauthorized" && transaction["error_messages"].nil?
              transaction = transaction["charges"][0]
              return create_valid_payment_transaction(transaction)
            else
              create_unpaid_payment_transaction("error")
            end
          end

        rescue Exception => e
          return create_unpaid_payment_transaction(e.message)
        end
      end

      def make_payment_invoice
        begin
          url_helper = Rails.application.routes.url_helpers

          if Rails.env.production?
            notification_url = url_helper.notify_change_payment_url
          else
            notification_url = ENV['HOST']+'notify_change_payment'
          end

          correct_price = @value

          values = {
            reference_id: @reference_id,
            description: @description,
            amount: {
              value: (correct_price * 100).to_i,
              currency: "BRL"
            },
            payment_method: {
              type: "BOLETO",
              boleto: {
                due_date: @due_date.to_date,
                instruction_lines: {
                  line_1: @description
                },
                holder: {
                  name: @payer.name,
                  tax_id: @payer.get_document_clean,
                  email: @payer.email,
                  address: {
                    country: "Brasil",
                    region: @order.get_state_name,
                    region_code: @order.get_state_acronym,
                    city: @order.get_city_name,
                    postal_code: @order.get_zipcode_clean,
                    street: @order.get_address_address,
                    number: @order.get_address_number,
                    locality: @order.get_address_district
                  }
                }
              }
            },
            notification_urls: [
              notification_url
            ]
          }.to_json

          url = URI(@url+"/charges")

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["Content-Type"] = "application/json"
          request["x-api-version"] = "4.0"
          request["Authorization"] = @token
          request.body = values

          response = https.request(request)
          transaction = JSON.parse(response.read_body)
          return create_valid_payment_transaction(transaction)

        rescue Exception => e
          return create_unpaid_payment_transaction(e.message)
        end
      end

      def make_payment_invoice_order
        begin
          correct_number = @card.number.gsub(' ','')

          if Rails.env.production?
            capture = true
          elsif Rails.env.development?
            capture = true
          end

          url_helper = Rails.application.routes.url_helpers

          if Rails.env.production?
            notification_url = url_helper.notify_change_payment_url
          else
            notification_url = ENV['HOST']+'notify_change_payment'
          end

          correct_price = @value

          values_charge = {
            reference_id: @reference_id,
            description: @description,
            amount: {
              value: (correct_price * 100).to_i,
              currency: "BRL"
            },
            payment_method: {
              type: "BOLETO",
              boleto: {
                due_date: @due_date.to_date,
                instruction_lines: {
                  line_1: @description
                },
                holder: {
                  name: @payer.name,
                  tax_id: @payer.get_document_clean,
                  email: @payer.email,
                  address: {
                    country: "Brasil",
                    region: @order.get_state_name,
                    region_code: @order.get_state_acronym,
                    city: @order.get_city_name,
                    postal_code: @order.get_zipcode_clean,
                    street: @order.get_address_address,
                    number: @order.get_address_number,
                    locality: @order.get_address_district
                  }
                }
              }
            },
            notification_urls: [
              notification_url
            ]
          }

          values = {
            reference_id: @reference_id,
            customer: {
              name: @payer.name,
              email: @payer.email,
              tax_id: @payer.get_document_clean
            },
            items: [
              {
                reference_id: @order.id.to_s,
                name: "Pedido: "+@order.id.to_s,
                quantity: 1,
                unit_amount: (correct_price * 100).to_i
              }
            ],
            charges: [
              values_charge
            ],
            notification_urls: [
              notification_url
            ]
          }.to_json

          url = URI(@url+"/orders")

          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true

          request = Net::HTTP::Post.new(url)
          request["Content-Type"] = "application/json"
          request["x-api-version"] = "4.0"
          request["Authorization"] = @token
          request.body = values

          response = https.request(request)
          transaction = JSON.parse(response.read_body)
          if transaction["message"] != "Unauthorized" && transaction["error_messages"].nil?
            transaction = transaction["charges"][0]
            return create_valid_payment_transaction(transaction)
          else
            create_unpaid_payment_transaction("error")
          end
        rescue Exception => e
          return create_unpaid_payment_transaction(e.message)
        end
      end

      def make_payment_pix

        begin

          # Recalculando o valor do PIX
          @order.order_carts.each do |order_cart|
            order_cart.save!
          end
          @order.save!
          @value = @order.get_total_price

          system_configuration = SystemConfiguration.first
          expiration_date = DateTime.now + 20.minutes

          current_reference_id = "pix_transaction_"+@reference_id.to_s
          customer = @order.user

          customer = {
            name: customer.name,
            email: customer.email,
            tax_id: customer.get_document_clean
          }

          items = [
            {
              reference_id: ("Compra MT - #"+@reference_id.to_s),
              name: "Compra MT -",
              quantity: "1",
              unit_amount: "1"
            }
          ]

          qr_codes = [
            {
              amount: {
                value: (@value*100).to_i
              },
              expiration_date: expiration_date
            }
          ]

          notification_urls = [
            ENV["HOST"]+"/notify_pix_payment"
          ]

          service = Utils::PagSeguro::CreateOrderService.new(current_reference_id, customer, items, qr_codes, nil, notification_urls)
          transaction = service.call

          if transaction[0]

            if @order.get_total_price == 0
              if Rails.env.development?
                Rails.logger.info "-- make_payment_pix transaction --"
                Rails.logger.info transaction[1]
              end
              return create_valid_payment_transaction(transaction[1])
            else
              transaction_pix = transaction[1]
              payment_amount = transaction_pix["qr_codes"][0]["amount"]["value"]
              pix_order_id = transaction_pix["id"]
              pix_text = transaction_pix["qr_codes"][0]["text"]
              pix_qrcode_link = transaction_pix["qr_codes"][0]["links"][0]["href"]

              payment_transaction = create_object_payment_transaction_pix(@order, PaymentStatus::AGUARDANDO_PAGAMENTO_ID, payment_amount, pix_order_id, pix_text, pix_qrcode_link, expiration_date)
              message = PaymentTransaction.human_attribute_name(:pix_generated)
              @order.update_columns(order_status_id: OrderStatus::AGUARDANDO_PAGAMENTO_ID)

              return [true, true, message, payment_transaction]
            end
          else
            return [false, nil, transaction[2], transaction[2]]
          end

        rescue Exception => e
          Rails.logger.error e.message
          return [false, nil, e.message, e.message]
        end
      end

      def create_valid_payment_transaction(transaction)
        payment_message = ''
        payment_id = ''
        payment_status = ''
        payment_amount = ''
        boleto_id = ''
        barcode = ''
        formatted_barcode = ''
        due_date = ''
        pdf_link = ''
        png_link = ''

        if @order.get_total_price == 0
          payment_status = PaymentStatus::PAGO_ID
          payment_message = "Pagamento sem valor (R$ 0,00) (uso de cupom de desconto)"
        else
          if transaction["message"] != "Unauthorized" && transaction["error_messages"].nil?
            payment_id = transaction["id"]
            payment_amount = (transaction["amount"]["value"].to_f)/100

            if !transaction["payment_method"].nil? && transaction["payment_method"]["type"] == 'BOLETO'
              boleto_id = transaction["payment_method"]["boleto"]["id"]
              barcode = transaction["payment_method"]["boleto"]["barcode"]
              formatted_barcode = transaction["payment_method"]["boleto"]["formatted_barcode"]
              due_date = transaction["payment_method"]["boleto"]["due_date"]
              pdf_link = transaction["links"][0]["href"]
              png_link = transaction["links"][1]["href"]
              payment_status = PaymentStatus::AGUARDANDO_PAGAMENTO_ID
            elsif !transaction["payment_method"].nil? && transaction["payment_method"]["type"] == 'CREDIT_CARD'
              payment_status = transaction["payment_response"]["code"].to_i
            end

            if !transaction["payment_response"].nil?
              payment_message = payment_status.to_s+'/'+transaction["payment_response"]["message"]
            else
              payment_message = payment_status.to_s+'/'+PaymentTransaction.human_attribute_name(:unpaid)
            end

          else
            payment_message = PaymentTransaction.human_attribute_name(:unpaid)
            payment_status = PaymentStatus::NAO_AUTORIZADO_ID
          end

          if payment_status != PaymentStatus::AGUARDANDO_PAGAMENTO_ID
            if payment_status.to_s == '20000'
              payment_status = PaymentStatus::PAGO_ID
            else
              payment_status = PaymentStatus::NAO_AUTORIZADO_ID
            end
          end
        end

        billet_informations = []
        billet_informations.push(boleto_id)
        billet_informations.push(barcode)
        billet_informations.push(formatted_barcode)
        billet_informations.push(due_date)
        billet_informations.push(pdf_link)
        billet_informations.push(png_link)

        paid = false
        message = PaymentTransaction.human_attribute_name(:unpaid)
        if payment_status == PaymentStatus::AGUARDANDO_PAGAMENTO_ID
          @order.update_columns(order_status_id: OrderStatus::AGUARDANDO_PAGAMENTO_ID)
          paid = true
          message = PaymentTransaction.human_attribute_name(:invoice_generated)
        elsif payment_status == PaymentStatus::PAGO_ID
          @order.update_columns(order_status_id: OrderStatus::PAGAMENTO_REALIZADO_ID, created_at: DateTime.now)
          paid = true
          message = PaymentTransaction.human_attribute_name(:paid)
        end

        transaction = create_object_payment_transaction(@order,
          payment_message,
          payment_id,
          payment_status,
          payment_amount,
          billet_informations
          )

        return [true, paid, message, transaction]
      end

      def create_unpaid_payment_transaction(message)
        transaction = create_object_payment_transaction(@order, message, nil, PaymentStatus::NAO_PAGO_ID, @value, [])
        return [false, false, PaymentTransaction.human_attribute_name(:unpaid), transaction]
      end

      def create_object_payment_transaction(object,  payment_message, payment_id, payment_status, payment_amount, billet_informations)
        return PaymentTransaction.create(
          ownertable: object, 
          payment_message: payment_message, 
          payment_code: payment_id, 
          payment_status_id: payment_status, 
          value: payment_amount,
          invoice_id: billet_informations[0],
          invoice_barcode: billet_informations[1],
          invoice_barcode_formatted: billet_informations[2],
          due_date: billet_informations[3],
          pdf_link: billet_informations[4],
          png_link: billet_informations[5])
      end

      def create_object_payment_transaction_pix(object, payment_status, payment_amount, pix_order_id, pix_text, pix_qrcode_link, expiration_date)
        return PaymentTransaction.create(
          ownertable: object, 
          payment_status_id: payment_status, 
          value: payment_amount,
          pix_order_id: pix_order_id,
          pix_text: pix_text,
          pix_limit_payment_date: expiration_date,
          pix_qrcode_link: pix_qrcode_link)
      end

    end
  end
end
