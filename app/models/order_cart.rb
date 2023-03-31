class OrderCart < ApplicationRecord
	after_initialize :default_values
	after_save :set_price_total

	belongs_to :order
	belongs_to :ownertable, :polymorphic => true
	belongs_to :seller_coupon

	belongs_to :user, -> { where(order_carts: {ownertable_type: 'User'}) }, foreign_key: 'ownertable_id'

	validates_presence_of :order_id, :quantity

	def as_json(options = {})
		{
			:id => self.id,
			:created_at => self.created_at,
			:updated_at => self.updated_at,
			:order_id => self.order_id,
			:ownertable => self.ownertable,
			:quantity => self.quantity,
			:unity_price => self.unity_price,
			:total_value => self.total_value,
			:freight_value => self.freight_value,
			:freight_value_total => self.freight_value_total,
			:created_at_formatted => CustomHelper.get_text_date(self.created_at, 'datetime', :full),
			:updated_at_formatted => CustomHelper.get_text_date(self.updated_at, 'datetime', :full),
			:unity_price_formatted => CustomHelper.to_currency(self.unity_price),
			:total_value_formatted => CustomHelper.to_currency(self.total_value),
			:freight_value_formatted => CustomHelper.to_currency(self.freight_value),
			:freight_value_total_formatted => CustomHelper.to_currency(self.freight_value_total)
		}
	end

	def self.format_order_cart_in_products(order_carts)
		products = []
		begin
			order_carts.each do |order_cart|
				current_product = order_cart.ownertable
				if !current_product.nil? && order_cart.ownertable_type == "Product"
					current_postalcode_from = ""
					address_id = nil
					selected_address_id = nil
					if !current_product.selected_address.nil? && (!current_product.selected_address.zipcode.nil? && !current_product.selected_address.zipcode.blank?)
						current_postalcode_from = CustomHelper.get_clean_text(current_product.selected_address.zipcode)
						selected_address_id = current_product.selected_address_id
					elsif !current_product.address.nil? && (!current_product.address.zipcode.nil? && !current_product.address.zipcode.blank?)
						current_postalcode_from = CustomHelper.get_clean_text(current_product.address.zipcode)
						address_id = current_product.address.id
					end
					if !current_postalcode_from.blank?
						product_data = {
							id: current_product.id,
							name: current_product.title,
							quantity: order_cart.quantity,
							unitary_value: order_cart.unity_price,
							width: current_product.width.to_f,
				            height: current_product.height.to_f,
				            length: current_product.depth.to_f,
				            weight: current_product.weight.to_f,
				            postalcode_from: current_postalcode_from,
				            address_id: address_id,
				            selected_address_id: selected_address_id
						}
						products.push(product_data)
					end
				end
			end
			return products
		rescue Exception => e
			Rails.logger.error "-- format_order_cart_in_products --"
			Rails.logger.error e.message
			return []
		end
	end

	def get_total_value
		result = 0
		result += (self.total_value + self.freight_value_total)
		return result
	end

	private

	def default_values
		self.quantity ||= 1
		self.freight_value ||= 0
		self.discount_coupon_value ||= 0
		self.discount_coupon_text ||= ""
	end

	def set_price_total
		if self.order.order_status_id == OrderStatus::EM_ABERTO_ID || self.order.order_status_id == OrderStatus::EM_ABERTO_COMPRA_PLANOS_ID
			price = self.ownertable.get_price
			quantity = self.quantity
			total_value = (price * quantity)
			freight_value_total = (self.freight_value*quantity)
			discount_by_discount_coupon = 0
			discount_coupon_value = 0
			discount_coupon_text = ""

			if !self.seller_coupon.nil?
				discount_coupon_text = self.seller_coupon.name
				discount_by_discount_coupon = self.seller_coupon.get_correct_value_discount(total_value)
				total_value = total_value - discount_by_discount_coupon.abs
				if total_value < 0
					total_value = 0
				end
			end
			
			self.update_columns(
				unity_price: price, 
				quantity: quantity, 
				total_value: total_value, 
				freight_value: self.freight_value, 
				freight_value_total: freight_value_total,
				discount_coupon_text: discount_coupon_text,
				discount_coupon_value: discount_by_discount_coupon.abs
				)
		end
	end
	
end
