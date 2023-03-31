class Visitors::ProductsController < ApplicationController
	skip_before_action :authenticate_user
	
	def show_product
		@product = Product.to_show_in_site.where(id: params[:id]).first
		get_data_to_show(BannerArea::PRODUTOS_ID)
		@array_images = Product.get_array_images_to_show(@product)

		@similar_products = []
		if !@product.nil?
			@similar_products = Product.to_show_in_site
			.by_category_id(@product.category_id)
			.where(id: params[:id])
			.order("RAND()")
			.limit(4)
		end
	end

end