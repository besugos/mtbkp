class Visitors::HomeController < ApplicationController
	skip_before_action :authenticate_user
	
	def index
		get_data_to_show(BannerArea::PAGINA_INICIAL_ID)
		@products = Product.to_show_in_site.order("RAND()").limit(4)

		Product.getting_all_values_with_tax(142.52)
	end

	def by_text_filter_products
		text_to_find = ""
		if !params[:product_text].nil?
			text_to_find = params[:product_text].to_s.split(' ')
		end
		if text_to_find.length > 0
			query = '('
			text_to_find.each do |text|
				if query.length > 1
					query += ' OR '
				end
				query += "lower(products.title) LIKE '%"+text.downcase+"%' 
				OR lower(products.description) LIKE '%"+text.downcase+"%' 
				OR lower(categories.name) LIKE '%"+text.downcase+"%'"
			end
			query += ')'
		else
			query = ""
		end
		@products = Product
		.where(query)
		.to_show_in_site
		.joins(:category)
		.joins(:sub_category)
		.page(params[:page])
		.per(28)
		get_data_to_show(BannerArea::PRODUTOS_ID)
	end

	def by_text_filter_services
		text_to_find = ""
		if !params[:product_text].nil?
			text_to_find = params[:product_text].to_s.split(' ')
		end
		if text_to_find.length > 0
			query = '('
			text_to_find.each do |text|
				if query.length > 1
					query += ' OR '
				end
				query += "lower(services.name) LIKE '%"+text.downcase+"%' 
				OR lower(services.description) LIKE '%"+text.downcase+"%' 
				OR lower(services.tags) LIKE '%"+text.downcase+"%' 
				OR lower(categories.name) LIKE '%"+text.downcase+"%'"
			end
			query += ')'
		else
			query = ""
		end
		if !session[:current_latitude].nil? && !session[:current_longitude].nil?
			@services_result = Service
			.where(query)
			.to_show_in_site
			.joins(:category)
			.joins(:address)
			@services = Service.formatting_array_based_location(session[:current_latitude], session[:current_longitude], @services_result)
		else
			@services = Service
			.where(query)
			.to_show_in_site
			.joins(:category)
			.page(params[:page])
			.per(28)
		end
		get_data_to_show(BannerArea::SERVICOS_ID)
	end

	def products_by_category
		@products = Product.to_show_in_site
		.by_category_id(params[:category_id])
		.by_sub_category_id(params[:sub_category_id])
		.page(params[:page])
		.per(28)
		get_data_to_show(BannerArea::PRODUTOS_ID)
		define_category_data
	end

	def services_by_category
		if !session[:current_latitude].nil? && !session[:current_longitude].nil?
			@services_result = Service.to_show_in_site
			.by_category_id(params[:category_id])
			.by_sub_category_id(params[:sub_category_id])
			@services = Service.formatting_array_based_location(session[:current_latitude], session[:current_longitude], @services_result)
		else
			@services = Service.to_show_in_site
			.by_category_id(params[:category_id])
			.by_sub_category_id(params[:sub_category_id])
			.page(params[:page])
			.per(28)
		end
		get_data_to_show(BannerArea::SERVICOS_ID)
		define_category_data
	end

	def define_category_data
		@category_name = ""
		if params[:category_id]
			category = Category.where(id: params[:category_id]).first
			if category
				@category_name = category.name
			end
		end

		@sub_category_name = ""
		if params[:sub_category_id]
			sub_category = SubCategory.where(id: params[:sub_category_id]).first
			if sub_category
				@sub_category_name = sub_category.name
			end
		end
	end

	def show_professional
		@professional = User.user.is_professional_validated.where(id: params[:id]).first
	end


	def products_by_professional
		@professional = User.user.is_professional_validated.where(id: params[:id]).first
		if @professional
			@products = Product.to_show_in_site
			.by_user_id(params[:id])
			.page(params[:page])
			.per(28)
			get_data_to_show(BannerArea::PRODUTOS_ID)
			define_category_data
		else
			redirect_to root_path
		end
	end

	def services_by_professional
		@professional = User.user.is_professional_validated.where(id: params[:id]).first
		if @professional
			if !session[:current_latitude].nil? && !session[:current_longitude].nil?
				@services_result = Service.to_show_in_site
				.by_user_id(params[:id])
				@services = Service.formatting_array_based_location(session[:current_latitude], session[:current_longitude], @services_result)
			else
				@services = Service.to_show_in_site
				.by_user_id(params[:id])
				.page(params[:page])
				.per(28)
			end
			get_data_to_show(BannerArea::SERVICOS_ID)
			define_category_data
		else
			redirect_to root_path
		end
	end

	def services_by_all_filters
		text_to_find = !params[:informations].nil? ? params[:informations].split(' ') : []
		query = ''
		text_to_find.each do |text|
			if !query.blank?
				query += ' AND '
			end
			query += "lower(services.name) LIKE '%"+text.downcase+"%' OR lower(services.tags) LIKE '%"+text.downcase+"%' OR lower(services.description) LIKE '%"+text.downcase+"%'"
		end
		if !session[:current_latitude].nil? && !session[:current_longitude].nil?
			@services_result = Service
			.to_show_in_site
			.where(query)
			.by_service_goal_id(params[:service_goal_id])
			.by_service_ground_id(params[:service_ground_id])
			.by_service_ground_type_id(params[:service_ground_type_id])
			@services = Service.formatting_array_based_location(session[:current_latitude], session[:current_longitude], @services_result)
		else
			@services = Service
			.to_show_in_site
			.where(query)
			.by_service_goal_id(params[:service_goal_id])
			.by_service_ground_id(params[:service_ground_id])
			.by_service_ground_type_id(params[:service_ground_type_id])
			.page(params[:page])
			.per(28)
		end
		get_data_to_show(BannerArea::SERVICOS_ID)
	end

end