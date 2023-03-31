class Product < ApplicationRecord
	after_initialize :default_values
	attr_accessor :images

	belongs_to :category
	belongs_to :sub_category
	belongs_to :product_condition
	belongs_to :user
	belongs_to :selected_address, :class_name => 'Address'

	validates_presence_of :title, :price, :user_id, :product_condition_id, :category_id

	has_many :attachments, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :attachments, :reject_if => :all_blank

	has_one :address, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :address
	
	has_one_attached :principal_image
	
	# has_attached_file :principal_image,
	# :storage => :s3,
	# :url => ":s3_domain_url",
	# styles: { medium: "300x300#", thumb: "100x100#", select: "50x50#" },
	# :path => ":class/principal_image/:id_partition/:style/:filename"
	# do_not_validate_attachment_file_type :principal_image

	scope :by_title, lambda { |value| where("LOWER(products.title) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }

	scope :by_initial_price, lambda { |value| where("price >= '#{value}'") if !value.nil? && !value.blank? }
	scope :by_final_price, lambda { |value| where("price <= '#{value}'") if !value.nil? && !value.blank? }

	scope :by_category_id, lambda { |value| where("products.category_id = ?", value) if !value.nil? && !value.blank? }
	scope :by_sub_category_id, lambda { |value| where("products.sub_category_id = ?", value) if !value.nil? && !value.blank? }

	scope :by_product_condition_id, lambda { |value| where("products.product_condition_id = ?", value) if !value.nil? && !value.blank? }
	scope :by_user_id, lambda { |value| where("products.user_id = ?", value) if !value.nil? && !value.blank? }

	scope :to_show_in_site, -> {
		joins(:user).where(users: {seller_verified: true})
		.joins(:user).where(users: {publish_professional_profile: true})
		.joins(user: :data_professional)
		.where(users: {data_professionals: {professional_document_status_id: ProfessionalDocumentStatus::VALIDADO_ID}})
		.where("quantity_stock > 0")
	}

	def get_text_name
		return self.title
	end

	def get_image
		result = ""
		begin
			if !self.principal_image.attached?
				result = "https://via.placeholder.com/100"
			else
				result = self.principal_image.variant(resize_to_limit: [100,100]).processed.url
			end
		rescue Exception => e
			result = "https://via.placeholder.com/100"
		end
		return result
	end
	
	def price=(new_price)
		new_price = new_price.to_s
		if new_price.include?('.')
			new_price = new_price.gsub!('.', '')
		end
		if new_price.include?('R$')
			new_price = new_price.gsub!('R$', '')
		end
		if new_price.include?('%')
			new_price = new_price.gsub!('%', '')
		end
		if new_price.include?(',')
			new_price = new_price.gsub!(',', '.')
		end
		new_price = new_price.to_f
		self[:price] = new_price
	end
	
	def promotional_price=(new_promotional_price)
		new_promotional_price = new_promotional_price.to_s
		if new_promotional_price.include?('.')
			new_promotional_price = new_promotional_price.gsub!('.', '')
		end
		if new_promotional_price.include?('R$')
			new_promotional_price = new_promotional_price.gsub!('R$', '')
		end
		if new_promotional_price.include?('%')
			new_promotional_price = new_promotional_price.gsub!('%', '')
		end
		if new_promotional_price.include?(',')
			new_promotional_price = new_promotional_price.gsub!(',', '.')
		end
		new_promotional_price = new_promotional_price.to_f
		self[:promotional_price] = new_promotional_price
	end
	
	def get_price
		if !self.promotional_price.nil? && !self.promotional_price.blank? && self.promotional_price > 0
			self.promotional_price
		else
			self.price
		end
	end

	def get_url_image
		result = nil
		if self.principal_image.attached?
			result = self.principal_image.url
		end
		return result
	end

	def get_title
		return self.title
	end

	def get_html_text
		result = ""
		if !self.principal_image.attached? 
			result = '<span><img src="'+self.principal_image.url(:select)+'" alt="'+self.get_text_name+'"> '+self.get_text_name+' </span>'
		else
			result = '<span><img src="https://via.placeholder.com/50/1247C7/FFFFFF/?text=Sem imagem" alt="'+self.get_text_name+'"> '+self.get_text_name+' </span>'
		end
		return result
	end

	def self.get_array_images_to_show(product)
		result = []
		if !product.nil?
			if product.principal_image.attached?
				object = {
					link: product.get_url_image,
					image: product.get_image,
					image_mobile: product.get_image
				}
				result.push(object)
			end
			product.attachments.each do |attachment|
				object = {
					link: attachment.get_url_image,
					image: attachment.get_image,
					image_mobile: attachment.get_image
				}
				result.push(object)
			end
		end
		return result
	end

	def self.getting_all_values_with_tax(price)
		result = []
		if !price.nil? && !price.blank?
			price = price.to_s
			if price.include?('R$')
				if price.include?('.')
					price = price.gsub!('.', '')
				end
				if price.include?('R$')
					price = price.gsub!('R$', '')
				end
				if price.include?('%')
					price = price.gsub!('%', '')
				end
				if price.include?(',')
					price = price.gsub!(',', '.')
				end
			end
			price = price.to_f
			system_configuration = SystemConfiguration.first
			tax_product = system_configuration.percent_order_products

			current_price = price - (price * ((tax_product+3.99)/100))
			result.push({
				name: "(1x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+8.32)/100))
			result.push({
				name: "(2x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+9.69)/100))
			result.push({
				name: "(3x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+10.05)/100))
			result.push({
				name: "(4x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+12.37)/100))
			result.push({
				name: "(5x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+13.67)/100))
			result.push({
				name: "(6x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+14.95)/100))
			result.push({
				name: "(7x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+16.21)/100))
			result.push({
				name: "(8x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+17.44)/100))
			result.push({
				name: "(9x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+18.65)/100))
			result.push({
				name: "(10x)",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+3.99)/100))
			result.push({
				name: "Boleto",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})

			current_price = price - (price * ((tax_product+1.89)/100))
			result.push({
				name: "PIX",
				value: current_price,
				value_formatted: CustomHelper.to_currency(current_price)
			})
		end
		return result
	end
	
	def get_correct_address
		result = nil
		if !self.selected_address.nil?
			result = self.selected_address
		else
			result = self.address
		end
		return result
	end

	def self.format_products_to_melhor_envio(products_formatted)
		result = []
		products_formatted.each do |product|
			product = {
				name: product[:name],
				quantity: product[:quantity],
				unitary_value: product[:unitary_value]
			}
			result.push(product)
		end
		return result
	end

	private

	def default_values
		self.title ||= ""
		self.product_condition_id ||= ProductCondition::NOVO_ID
	end	
end

# End of file product.rb
# Path: ./app/models/product.rb
