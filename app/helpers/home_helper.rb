module HomeHelper
	
	def get_categories_to_show_site
		return Category.order("RAND()").limit(4)
	end

end
