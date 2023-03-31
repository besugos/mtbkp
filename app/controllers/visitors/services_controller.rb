class Visitors::ServicesController < ApplicationController
	skip_before_action :authenticate_user
	
	def show_service
		if !session[:current_latitude].nil? && !session[:current_longitude].nil?
			@service_result = Service.to_show_in_site.where(id: params[:id]).first
			services = Service.formatting_array_based_location(session[:current_latitude], session[:current_longitude], [@service_result])
			if services.length > 0
				@service = services[0]
				service = services[0][:service]
			end
		else
			@service = Service.to_show_in_site.where(id: params[:id]).first
			service = @service
		end
		get_data_to_show(BannerArea::SERVICOS_ID)
		@array_images = Service.get_array_images_to_show(service)

		@similar_services = []
		if !@service.nil?
			if !session[:current_latitude].nil? && !session[:current_longitude].nil?
				@services_result = Service.to_show_in_site
				.by_category_id(service.category_id)
				.where(id: params[:id])
				.order("RAND()")
				.limit(4)
				@similar_services = Service.formatting_array_based_location(session[:current_latitude], session[:current_longitude], @services_result)
			else
				@similar_services = Service.to_show_in_site
				.by_category_id(service.category_id)
				.where(id: params[:id])
				.order("RAND()")
				.limit(4)
			end
		end
	end

end