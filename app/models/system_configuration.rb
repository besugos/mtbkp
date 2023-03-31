class SystemConfiguration < ApplicationRecord
	after_initialize :default_values

	SOBRE = 'sobre'
	POLITICA_USO = 'politica_uso'
	POLITICA_PRIVACIDADE = 'politica_privacidade'
	TROCAS_DEVOLUCOES = 'trocas_devolucoes'

	MINUTA_CONTRATO = 'minuta_contrato'
	CONDICOES_GERAIS = 'condicoes_gerais'

	has_one :address, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :address
	
	has_one_attached :client_logo
	
	has_one_attached :about_image

	has_one_attached :favicon

	has_one_attached :footer_image

	has_one_attached :size_banner_image
	
	has_one_attached :size_banner_image_mobile

	def plan_price=(new_plan_price)
		new_plan_price = new_plan_price.to_s
		if new_plan_price.include?('.')
			new_plan_price = new_plan_price.gsub!('.', '')
		end
		if new_plan_price.include?('R$')
			new_plan_price = new_plan_price.gsub!('R$', '')
		end
		if new_plan_price.include?('%')
			new_plan_price = new_plan_price.gsub!('%', '')
		end
		if new_plan_price.include?(',')
			new_plan_price = new_plan_price.gsub!(',', '.')
		end
		new_plan_price = new_plan_price.to_f
		self[:plan_price] = new_plan_price
	end

	# has_attached_file :client_logo,
	# :storage => :s3,
	# :url => ":s3_domain_url", 
	# :path => ":class/client_logo/:id_partition/:style/:filename"
	# do_not_validate_attachment_file_type :client_logo
	
	# has_attached_file :about_image,
	# :storage => :s3,
	# :url => ":s3_domain_url", 
	# styles: { medium: "300x300#", thumb: "100x100#"},
	# :path => ":class/about_image/:id_partition/:style/:filename"
	# do_not_validate_attachment_file_type :about_image
	
	# has_attached_file :favicon,
	# :storage => :s3,
	# :url => ":s3_domain_url",
	# styles: { 
	# 	'sizes57x57': "57x57#",
	# 	'sizes60x60': "60x60#",
	# 	'sizes72x72': "72x72#",
	# 	'sizes76x76': "76x76#",
	# 	'sizes114x114': "114x114#",
	# 	'sizes120x120': "120x120#",
	# 	'sizes144x144': "144x144#",
	# 	'sizes152x152': "152x152#",
	# 	'sizes180x180': "180x180#",
	# 	'sizes192x192': "192x192#",
	# 	'sizes32x32': "32x32#",
	# 	'sizes96x96': "96x96#",
	# 	'sizes16x16': "16x16#",
	# },
	# :path => ":class/favicon/:id_partition/:style/:filename"
	# do_not_validate_attachment_file_type :favicon

	# def site_link=(new_site_link)
	# 	if !new_site_link.nil?
	# 		new_site_link = new_site_link.to_s
	# 		new_site_link = new_site_link.gsub!(' ', '')
	# 		self[:site_link] = new_site_link
	# 	end
	# end

	# def facebook_link=(new_facebook_link)
	# 	if !new_facebook_link.nil?
	# 		new_facebook_link = new_facebook_link.to_s
	# 		new_facebook_link = new_facebook_link.gsub!(' ', '')
	# 		self[:facebook_link] = facebook_link
	# 	end
	# end

	# def instagram_link=(new_instagram_link)
	# 	if !new_instagram_link.nil?
	# 		new_instagram_link = new_instagram_link.to_s
	# 		new_instagram_link = new_instagram_link.gsub!(' ', '')
	# 		self[:instagram_link] = instagram_link
	# 	end
	# end

	# def twitter_link=(new_twitter_link)
	# 	if !new_twitter_link.nil?
	# 		new_twitter_link = new_twitter_link.to_s
	# 		new_twitter_link = new_twitter_link.gsub!(' ', '')
	# 		self[:twitter_link] = twitter_link
	# 	end
	# end

	private
	def default_values
		
		self.notification_mail ||= ''
		self.phone ||= ''
		self.cellphone ||= ''

		self.privacy_policy ||= ''
		self.use_policy ||= ''
		self.warranty_policy ||= ''
		self.exchange_policy ||= ''

		self.geral_conditions ||= ''
		self.contract_data ||= ''
		self.size_banner_link ||= ''

		self.data_security_policy ||= ''
		self.quality ||= ''
		self.about ||= ''
		self.mission ||= ''
		self.view ||= ''
		self.values ||= ''
		self.site_link ||= ''
		self.facebook_link ||= ''
		self.instagram_link ||= ''
		self.twitter_link ||= ''
		self.id_google_analytics ||= ''
		self.page_title ||= ''
		self.page_description ||= ''

	end
end
