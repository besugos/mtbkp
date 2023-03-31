class Order < ApplicationRecord
	after_initialize :default_values
	after_save :set_price_total

	belongs_to :order_status
	belongs_to :user
	belongs_to :payment_type
	belongs_to :seller_coupon
	belongs_to :order_type_recurrent

	attr_accessor :card_id, :address_id
	
	has_one :card, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :card

	has_one :address, as: :ownertable, dependent: :destroy
	accepts_nested_attributes_for :address

	has_many :cancel_orders, as: :ownertable, dependent: :destroy
	accepts_nested_attributes_for :cancel_orders

	validates_presence_of :order_status_id
	
	has_many :payment_transactions, as: :ownertable, dependent: :destroy
	
	has_many :freight_orders, dependent: :destroy
	accepts_nested_attributes_for :freight_orders

	# Itens do carrinho
	has_many :order_carts, dependent: :destroy
	accepts_nested_attributes_for :order_carts

	has_many :user_plans, dependent: :destroy
	has_many :messages, dependent: :destroy

	has_many :professional_avaliations, dependent: :destroy

	amoeba do
		enable
		exclude_association :payment_transactions
		exclude_association :user_plans
	end

	scope :by_user_id, lambda { |value| where("user_id = ?", value) if !value.nil? && !value.blank? }

	scope :by_seller_id, lambda { |values| joins(:order_carts).where(order_carts: {ownertable_type: 'Product'}).where(order_carts: {ownertable: {user_id: [values]}}) if !values.nil? && values.length > 0 }

	scope :by_order_status_id, lambda { |value| where("order_status_id = ?", value) if !value.nil? && !value.blank? }
	
	scope :by_payment_type_id, lambda { |value| where("payment_type_id = ?", value) if !value.nil? && !value.blank? }

	scope :by_plan_id, lambda { |value| 
		joins(:order_carts)
		.where("order_carts.ownertable_id = ?", value) if !value.nil? && !value.blank? 
	}
	
	scope :by_initial_date, lambda { |value| where("created_at >= '#{value} 00:00:00'") if !value.nil? && !value.blank? }
	scope :by_final_date, lambda { |value| where("created_at <= '#{value} 23:59:59'") if !value.nil? && !value.blank? }

	scope :by_initial_price, lambda { |value| where("price >= '#{value}'") if !value.nil? && !value.blank? }
	scope :by_final_price, lambda { |value| where("price <= '#{value}'") if !value.nil? && !value.blank? }

	scope :bought_plans, -> { joins(:order_carts).where("order_carts.ownertable_type = 'Plan'") }

	scope :bought_products, -> { joins(:order_carts).where("order_carts.ownertable_type = 'Product'") }

	def as_json(options = {})
		{
			:id => self.id,
			:created_at => self.created_at,
			:updated_at => self.updated_at,
			:order_status_id => self.order_status_id,
			:order_status => self.order_status,
			:user_id => self.user_id,
			:payment_type_id => self.payment_type_id,
			:payment_type => self.payment_type,
			:installments => self.installments,
			:price => self.price,
			:order_carts_length => self.order_carts.length,
			:total_value => self.total_value,
			:total_freight_value => self.total_freight_value,
			:created_at_formatted => CustomHelper.get_text_date(self.created_at, 'datetime', :full),
			:updated_at_formatted => CustomHelper.get_text_date(self.updated_at, 'datetime', :full),
			:price_formatted => CustomHelper.to_currency(self.price),
			:total_value_formatted => CustomHelper.to_currency(self.total_value),
			:total_freight_value_formatted => CustomHelper.to_currency(self.total_freight_value)
		}
	end

	# Adicionando elementos ao carrinho de compra
	def self.add_element_to_order(order, ownertable_type, ownertable_id, quantity)
		result = [false, Order.human_attribute_name(:add_failed)]
		element = nil

		# Buscando qual o tipo de elemento para ser adicionado
		if ownertable_type == 'Product'
			element = Product.where(id: ownertable_id).first
		elsif ownertable_type == 'Plan'
			element = Plan.where(id: ownertable_id).first
		end
		if !element.nil?
			quantity_stock = nil
			if ownertable_type == 'Product'
				quantity_stock = element.quantity_stock
			end
			
			quantity_to_add = (quantity.nil? || quantity.blank?) ? 1 : quantity.to_i
			order_cart = order.order_carts.select{|item| item.ownertable_type == ownertable_type && item.ownertable_id == element.id }.first
			
			if !order_cart.nil?
				if !quantity_stock.nil? && (order_cart.quantity + quantity_to_add) > quantity_stock
					correct_quantity = quantity_stock
				else
					correct_quantity = (order_cart.quantity + quantity_to_add)
				end
				order_cart.quantity = correct_quantity
				order_cart.save!
			else
				if !quantity_stock.nil? && quantity_to_add > quantity_stock
					correct_quantity = quantity_stock
				else
					correct_quantity = quantity_to_add
				end
				order.order_carts << OrderCart.create(ownertable: element, quantity: correct_quantity)
			end
			order.save!
			result = [true, Order.human_attribute_name(:add_success)]
		end
		return result
	end

	# Removendo elemento do carrinho
	def self.remove_element_to_order(order, order_cart_id)
		result = [false, Order.human_attribute_name(:remove_failed)]
		order_cart = order.order_carts.select{|item| item.id == order_cart_id.to_i}.first
		if order_cart
			order_cart.destroy
			order.save!
			result = [true, Order.human_attribute_name(:remove_success)]			
		end
		return result
	end

	# Verificando se é para apagar o item do carrinho se a quantidade for 0
	def self.validate_order_cart_quantity(order)
		order.order_carts.each do |order_cart|
			quantity_stock = nil
			if order_cart.ownertable_type == "Product"
				quantity_stock = order_cart.ownertable.quantity_stock
			end
			if order_cart.quantity == 0
				order_cart.destroy
			end
			if !quantity_stock.nil? && order_cart.quantity > quantity_stock
				order_cart.quantity = quantity_stock
				order_cart.save!
			end
		end
	end

	def get_total_price
		return self.total_value
	end

	def get_correct_freight_value
		return self.total_freight_value
	end

	def get_sum_discount_price_order_carts
		return self.order_carts.sum(:discount_coupon_value)
	end

	def is_address_valid?
		return (
			!self.address.nil? && 
			(!self.address.zipcode.nil? && !self.address.zipcode.blank?) && 
			(!self.address.number.nil? && !self.address.number.blank?) && 
			(!self.address.address.nil? && !self.address.address.blank?) && 
			(!self.address.district.nil? && !self.address.district.blank?) && 
			(!self.address.state_id.nil? && !self.address.state_id.blank?) && 
			(!self.address.city_id.nil? && !self.address.city_id.blank?) && 
			((self.order_status_id == OrderStatus::EM_ABERTO_ID && (CustomHelper.get_clean_text(self.zipcode_delivery) == CustomHelper.get_clean_text(self.address.zipcode))) || self.order_status_id == OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID)
			)
	end

	def self.get_installments(order, installments)
		array = []
		for i in 1..installments
			array.push([
				i.to_s+' x '+CustomHelper.to_currency(order.get_total_price/i).to_s, i
			])
		end
		return array
	end

	def self.validate_card_payment(order, card_params, card_id)
		if order.payment_type_id == PaymentType::CARTAO_CREDITO_ID
			if (!card_params.nil? || !card_id.nil?)
				if !card_params.nil? && !card_params.blank? && !card_params[:number].blank? && !card_params[:number].nil?
					# Se o pedido já possuir algum cartão vinculado
					if !order.card.nil?
						order.card.destroy
					end
					
					# Cartão para o pagamento
					new_card = Card.new(card_params)
					new_card.ownertable = order
					new_card.id = nil
					new_card.save

					# Cartão para o usuário corrente
					old_user_card = order.user.cards.select{|item| item.number == card_params[:number]}.first
					if old_user_card.nil?
						new_card_user = Card.new(card_params)
						new_card_user.ownertable = order.user
						new_card_user.id = nil
						card_to_use = new_card_user.save
					end
					order.reload
				elsif !card_id.nil? && !card_id.blank?
					# Busca o cartão selecionado
					card = Card.where(id: card_id).first
					if card
						# Se o pedido já possuir algum cartão vinculado
						if !order.card.nil?
							order.card.destroy
						end
						# Clona o cartão encontrado na busca e vincula a consulta
						new_card = card.dup
						new_card.id = nil
						new_card.ownertable = order
						card_to_use = new_card.save
						order.reload
					end
				end
			end
		end
	end

	def self.validate_address_payment(order, address_params, address_id)
		if (!address_params.nil? || !address_id.nil?)
			if !address_id.nil? && !address_id.blank?
				# Busca o endereço selecionado
				address = Address.where(id: address_id).first
				if address
					# Se o pedido já possuir algum endereço vinculado
					if !order.address.nil?
						order.address.destroy
					end
					# Clona o endereço encontrado na busca e vincula a consulta
					new_address = address.dup
					new_address.id = nil
					new_address.ownertable = order
					address_to_use = new_address.save
					order.reload
				end
			elsif !address_params.nil? && !address_params.blank?
				# Se o pedido já possuir algum endereço vinculado
				if !order.address.nil?
					order.address.destroy
				end
				
				# Endereço para o pedido
				new_address = Address.new(address_params)
				new_address.ownertable = order
				new_address.id = nil
				new_address.save

				# Endereço para o usuário corrente
				old_user_address = order.user.addresses.select{|item| item.zipcode == address_params[:zipcode] && item.number == address_params[:number]}.first
				if old_user_address.nil?
					if order.order_status_id == OrderStatus::EM_ABERTO_ID
						address_area_id = AddressArea::ENDERECO_ENTREGA_ID
					elsif order.order_status_id == OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID
						address_area_id = AddressArea::GENERAL_ID
					end
					new_address_user = Address.new(address_params)
					new_address_user.ownertable = order.user
					new_address_user.address_area_id = address_area_id
					new_address_user.id = nil
					address_to_use = new_address_user.save
				end
				order.reload
			end
		end
	end

	def get_state_name
		result = ''
		if !self.address.nil? && !self.address.state.nil?
			result = self.address.state.name
		end
		return result
	end

	def get_city_name
		result = ''
		if !self.address.nil? && !self.address.city.nil?
			result = self.address.city.name
		end
		return result
	end

	def get_state_acronym
		result = ''
		if !self.address.nil? && !self.address.state.nil?
			result = self.address.state.acronym
		end
		return result
	end

	def get_zipcode_clean
		result = ''
		if !self.address.nil? && !self.address.zipcode.nil?
			result = clean_text(self.address.zipcode)
		end
		return result
	end

	def get_address_address
		result = ''
		if !self.address.nil? && !self.address.address.nil?
			result = clean_text(self.address.address)
		end
		return result
	end

	def get_address_number
		result = ''
		if !self.address.nil? && !self.address.number.nil?
			result = clean_text(self.address.number)
		end
		return result
	end

	def get_address_district
		result = ''
		if !self.address.nil? && !self.address.district.nil?
			result = clean_text(self.address.district)
		end
		return result
	end

	def get_address_complement
		result = ''
		if !self.address.nil? && !self.address.complement.nil?
			result = clean_text(self.address.complement)
		end
		return result
	end

	def clean_text(text)
		result = text.gsub('.','')
		result = result.gsub(' ','')
		result = result.gsub('-','')
		result = result.gsub('/','')
		return result
	end

	def get_last_invoice_payment
		result = ''
		if self.payment_type_id == PaymentType::BOLETO_ID
			last_payment_transaction = self.payment_transactions.last
			result = last_payment_transaction.pdf_link
		end
		return result
	end

	def self.get_calculate_freigth_value(current_order, postalcode_to)
		group_sellers_freights = []
		order_carts_sellers = Order.get_order_formatted_by_sellers(current_order)
		order_carts_sellers.each do |order_carts_seller|
			order_carts = current_order.order_carts.select{|item| item.ownertable.user_id == order_carts_seller.id}
			current_products = OrderCart.format_order_cart_in_products(order_carts)
			if current_products.length > 0
				postalcode_from = current_products.first[:postalcode_from]
				service = Utils::MelhorEnvio::CalculateFreightService.new(postalcode_from, postalcode_to, current_products)
				transaction = service.call
				if transaction[0]
					options = transaction[2]
					options.each do |option|
						if option["error"].nil? || option["error"].blank?
							company = nil
							company_result = option["company"]
							if !company_result.nil?
								company_id = company_result["id"]
								freight_company = FreightCompany.find_or_create_by(melhor_envio_id: company_id, name: company_result["name"])
								if freight_company.picture_url.nil? || freight_company.picture_url.blank?
									freight_company.update_columns(picture_url: company_result["picture"])
								end
							end

							freight_order = current_order.freight_orders.select{|item| item.seller_id == order_carts_seller.id}.first
							if freight_order.nil?
								freight_order = FreightOrder.create(order_id: current_order.id, seller_id: order_carts_seller.id)
							end

							freight_order_option = freight_order.freight_order_options.select{|item| item.name == option["name"]}.first
							if freight_order_option.nil?
								freight_order_option = FreightOrderOption.create(freight_order_id: freight_order.id, name: option["name"])
							end
							price = option["price"].to_f + (option["price"].to_f * (0.1865))
							freight_order_option.update_columns(
								price: price,
								delivery_time: option["delivery_time"],
								freight_company_id: freight_company.id,
								melhor_envio_service_id: option["id"],
								melhor_envio_complete_data: option.to_json
								)
						end
						current_order.reload
					end
				end
			end
		end
	end

	def self.get_order_formatted_by_sellers(order)
		begin
			order_carts_sellers = []
			order_carts = order.order_carts
			order_carts.each do |order_cart|
				order_carts_sellers.push(order_cart.ownertable.user) if !order_carts_sellers.include?(order_cart.ownertable.user)
			end
			order_carts_sellers = order_carts_sellers.sort_by{|item| item.name}
			return order_carts_sellers
		rescue Exception => e
			Rails.logger.error "-- get_order_formatted_by_sellers --"
			Rails.logger.error e.message
			return []
		end
	end

	def self.validate_freight_to_buy_products(order)
		result = true
		if order.order_status_id == OrderStatus::EM_ABERTO_ID
			freight_orders = order.freight_orders
			freight_orders.each do |freight_order|
				has_selected_option = freight_order.freight_order_options.select{|item| item.selected}.length > 0
				if !has_selected_option
					result = false
				end
			end
			if result && (order.zipcode_delivery.nil? || order.zipcode_delivery.blank?)
				result = false
			end
		end
		return result
	end

	def self.setting_limit_cancel_order(order)
		begin
			order.freight_orders.each do |freight_order|
				freight_order.update_columns(limit_cancel_order: DateTime.now + 7.days)
			end
		rescue Exception => e
			Rails.logger.error "-- setting_limit_cancel_order --"
			Rails.logger.error e.message
		end
	end

	def self.get_order_total_products_by_seller(order, seller)
		begin
			result = order.order_carts.select{|item| item.ownertable.user_id == seller.id}.inject(0){|sum,x| sum + x.get_total_value}
			return result
		rescue Exception => e
			Rails.logger.error "-- get_order_total_products_by_seller --"
			Rails.logger.error e.message
		end
	end

	def self.get_order_price_by_seller(order, seller)
		begin
			result = Order.get_order_total_products_by_seller(order, seller)
			freight_order_option = Order.get_freight_order_option_by_seller(order, seller)
			result += freight_order_option
			return result
		rescue Exception => e
			Rails.logger.error "-- get_order_price_by_seller --"
			Rails.logger.error e.message
		end
	end

	def self.get_freight_order_option_by_seller(order, seller)
		begin
			result = 0
			freight_order = order.freight_orders.select{|item| item.seller_id == seller.id}.first
			if freight_order
				freight_order_option = freight_order.freight_order_options.select{|item| item.selected}.first
				if freight_order_option
					result += freight_order_option.price
				end
			end
			return result
		rescue Exception => e
			Rails.logger.error "-- get_freight_order_option_by_seller --"
			Rails.logger.error e.message
		end
	end

	def self.get_freight_order_object_by_seller(order, seller)
		begin
			freight_order = order.freight_orders.select{|item| item.seller_id == seller.id}.first
			return freight_order
		rescue Exception => e
			Rails.logger.error "-- get_freight_order_object_by_seller --"
			Rails.logger.error e.message
			return nil
		end
	end

	def self.get_freight_order_option_object_by_seller(order, seller)
		begin
			freight_order_option = nil
			freight_order = order.freight_orders.select{|item| item.seller_id == seller.id}.first
			if freight_order
				freight_order_option = freight_order.freight_order_options.select{|item| item.selected}.first
			end
			return freight_order_option
		rescue Exception => e
			Rails.logger.error "-- get_freight_order_option_by_seller --"
			Rails.logger.error e.message
		end
	end

	def self.get_receiver_value_by_seller(order, seller, insert_freight)
		begin
			value_to_receive = 0
			order_carts = order.order_carts.select{|item| item.ownertable.user_id == seller.id}
			order_carts.each do |order_cart|
				total_value = order_cart.total_value
				values = Product.getting_all_values_with_tax(total_value)
				if values.length > 0
					if order.payment_type_id == PaymentType::BOLETO_ID
						value_to_receive = values[10][:value]
					elsif order.payment_type_id == PaymentType::PIX_ID
						value_to_receive = values[11][:value]
					elsif order.payment_type_id == PaymentType::CARTAO_CREDITO_ID
						installments = order.installments
						value_to_receive = values[(installments-1)][:value]
					end
				end
			end
			if insert_freight
				value_to_receive += Order.get_freight_order_option_by_seller(order, seller)
			end
			return value_to_receive
		rescue Exception => e
			Rails.logger.error "-- get_receiver_value_by_seller --"
			Rails.logger.error e.message
		end
	end

	def self.generate_order_melhor_envio(order)
		begin
			first_order_cart = order.order_carts.first
			if !first_order_cart.nil? && first_order_cart.ownertable_type == "Product" && order.order_status_id == OrderStatus::PAGAMENTO_REALIZADO_ID
				to_user = order.user
				to_address = order.address
				to_data = User.generate_data_to_melhor_envio(to_user, to_address)
				order.freight_orders.each do |freight_order|
					from_user = freight_order.seller

					order_carts = order.order_carts.select{|item| item.ownertable.user_id == from_user.id}
					current_products = OrderCart.format_order_cart_in_products(order_carts)

					if current_products.length > 0
						address_id = nil
						first_product = current_products.first
						if !first_product[:address_id].nil?
							address_id = first_product[:address_id]
						elsif !first_product[:selected_address_id].nil?
							address_id = first_product[:selected_address_id]
						end
						from_address = Address.where(id: address_id).first
						if !from_address.nil?
							from_data = User.generate_data_to_melhor_envio(from_user, from_address)
							selected_freight_order_option = freight_order.freight_order_options.select{|item| item.selected}.first
							if !selected_freight_order_option.nil? && (selected_freight_order_option.melhor_envio_order_data.nil? || selected_freight_order_option.melhor_envio_order_data.blank?)
								service_id = selected_freight_order_option.melhor_envio_service_id
								products_formatted = Product.format_products_to_melhor_envio(current_products)
								volumes = FreightOrderOption.format_volume_to_melhor_envio(selected_freight_order_option)
								service = Utils::MelhorEnvio::PutDataInCartService.new(service_id, from_data, to_data, products_formatted, volumes, nil)
								transaction = service.call
								if transaction[0]
									result = transaction[2]
									selected_freight_order_option.update_columns(melhor_envio_order_data: result.to_json)
									Order.checkout_data_in_cart_melhor_envio(selected_freight_order_option.reload)
								end
							elsif !selected_freight_order_option.nil? && (selected_freight_order_option.melhor_envio_checkout_data.nil? || selected_freight_order_option.melhor_envio_checkout_data.blank?)
								Order.checkout_data_in_cart_melhor_envio(selected_freight_order_option)
							end
							Order.make_shipment_melhor_envio(selected_freight_order_option)
							Order.updating_status_selected_freight_order_option(selected_freight_order_option)
						end
					end
				end
			end
		rescue Exception => e
			Rails.logger.error "-- generate_order_melhor_envio --"
			Rails.logger.error e.message
		end
	end

	def self.checkout_data_in_cart_melhor_envio(selected_freight_order_option)
		begin
			order_data = JSON.parse(selected_freight_order_option.melhor_envio_order_data)
			order_id = order_data["id"]
			if !order_id.nil? && !order_id.blank? && (selected_freight_order_option.melhor_envio_checkout_data.nil? || selected_freight_order_option.melhor_envio_checkout_data.blank?)
				service = Utils::MelhorEnvio::CheckoutService.new(order_id)
				transaction = service.call
				if transaction[0]
					Rails.logger.info "-- tentantiva de checkout --"
					result = transaction[2]
					if result["errors"].nil?
						result_final = result["purchase"]
						selected_freight_order_option.update_columns(melhor_envio_checkout_data: result_final.to_json)
					else
						Rails.logger.info "-- busca do pedido --"
						show_service = Utils::MelhorEnvio::ShowOrderService.new(order_id)
						show_transaction = show_service.call
						if show_transaction[0]
							result_show_transaction = show_transaction[2]
							if !result_show_transaction["paid_at"].nil?
								selected_freight_order_option.update_columns(melhor_envio_checkout_data: result_show_transaction.to_json)
							end
						end
					end
				end
			end
		rescue Exception => e
			Rails.logger.error "-- checkout_data_in_cart_melhor_envio --"
			Rails.logger.error e.message
		end
	end

	def self.make_shipment_melhor_envio(selected_freight_order_option)
		begin
			order_data = JSON.parse(selected_freight_order_option.melhor_envio_order_data)
			order_id = order_data["id"]
			if !order_id.nil? && !order_id.blank? && !selected_freight_order_option.melhor_envio_checkout_data.nil?
				melhor_envio_checkout_data = JSON.parse(selected_freight_order_option.melhor_envio_checkout_data)
				if !melhor_envio_checkout_data["paid_at"].nil? && melhor_envio_checkout_data["generated_at"].nil?
					service = Utils::MelhorEnvio::MakeShipmentService.new(order_id)
					transaction = service.call
					if transaction[0]
						result = transaction[2]
						if result[order_id]["status"] == true
							Order.updating_status_selected_freight_order_option(selected_freight_order_option)
						end
					end
				end
			end
		rescue Exception => e
			Rails.logger.error "-- make_shipment_melhor_envio --"
			Rails.logger.error e.message
		end
	end

	def self.updating_status_selected_freight_order_option(selected_freight_order_option)
		begin
			if !selected_freight_order_option.melhor_envio_order_data.nil?
				order_data = JSON.parse(selected_freight_order_option.melhor_envio_order_data)
				order_id = order_data["id"]
				if !order_id.nil? && !order_id.blank?
					show_service = Utils::MelhorEnvio::ShowOrderService.new(order_id)
					show_transaction = show_service.call
					if show_transaction[0]
						result_show_transaction = show_transaction[2]
						if !result_show_transaction.nil?
							selected_freight_order_option.update_columns(melhor_envio_checkout_data: result_show_transaction.to_json)
						end
					end
				end
			end
		rescue Exception => e
			Rails.logger.error "-- updating_status_selected_freight_order_option --"
			Rails.logger.error e.message
		end
	end
	
	private

	def default_values
		self.order_status_id ||= OrderStatus::EM_ABERTO_ID
		self.payment_type_id ||= PaymentType::CARTAO_CREDITO_ID
		self.order_type_recurrent_id ||= OrderTypeRecurrent::RECURRENT_ID
		self.price ||= 0
		self.installments ||= 1
		self.total_freight_value ||= 0
		self.zipcode_delivery ||= ""
	end

	def set_price_total
		# Atualiza o valor do pedido baseado nos itens
		if self.order_status_id == OrderStatus::EM_ABERTO_ID || self.order_status_id == OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID
			
			price = self.order_carts.sum(:total_value)
			total_freight_value = 0
			self.freight_orders.each do |freight_order|
				total_freight_value += freight_order.freight_order_options.select{|item| item.selected}.inject(0){|sum,x| sum + x.price}
			end
			total_value = price + total_freight_value

			if !self.seller_coupon.nil?
				# Disconto para compra de planos de produtos e/ou serviços
				discount_by_seller_coupon = self.seller_coupon.get_correct_value_discount(total_value)
				total_value = total_value - discount_by_seller_coupon.abs
				if total_value < 0
					total_value = 0
				end
			else
				discount_by_seller_coupon = 0
			end

			discount_order_carts_value = self.order_carts.sum(:discount_coupon_value)
			total_value = total_value - discount_order_carts_value
			if total_value < 0
				total_value = 0
			end
			self.update_columns(
				price: price, 
				total_value: total_value, 
				total_freight_value: total_freight_value, 
				discount_by_seller_coupon: discount_by_seller_coupon.abs
				)
		end
	end
end
