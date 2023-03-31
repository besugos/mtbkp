module MenuHelper

	def get_complete_menu
		menu_links = []

		users_links = get_users_menu
		addresses_links = get_addresses_menu
		categories_links = get_categories_menu
		plans_links = get_plans_menu

		menu_links.push(users_links)

		if policy(@current_user).edit?
			menu_links.push({label: User.human_attribute_name(:my_data), href: edit_user_path(@current_user)}) 
		end
		
		if policy(@current_user).change_access_data?
			menu_links.push({label: User.human_attribute_name(:change_access_data), href: change_access_data_path(id: @current_user.id)}) 
		end
		
		if policy(@current_user).view_my_addresses?
			menu_links.push({label: User.human_attribute_name(:delivery_addresses), href: user_addresses_path(ownertable_type: "User", ownertable_id: @current_user.id, address_area_id: AddressArea::ENDERECO_ENTREGA_ID, page_title: User.human_attribute_name(:delivery_addresses))}) 
			menu_links.push({label: User.human_attribute_name(:output_addresses), href: user_addresses_path(ownertable_type: "User", ownertable_id: @current_user.id, address_area_id: AddressArea::ENDERECO_SAIDA_ID, page_title: User.human_attribute_name(:output_addresses))}) 
		end
		
		if policy(@current_user).view_my_cards?
			menu_links.push({label: Card.model_name.human(count: 2), href: user_cards_path(ownertable_type: "User", id: @current_user.id, page_title: Card.model_name.human(count: 2))}) 
		end
		
		if policy(Order).my_orders?
			menu_links.push({label: Order.human_attribute_name(:my_orders), href: my_orders_path }) 
		end
		
		if policy(Order).index?
			menu_links.push({label: Order.model_name.human(count: 2), href: orders_path }) 
		end

		if policy(Order).sold_products?
			label = @current_user.admin? ? Order.model_name.human(count: 2) : Order.human_attribute_name(:sold_products)
			menu_links.push({label: label, href: sold_products_path }) 
		end
		
		if policy(Order).bought_plans?
			menu_links.push({label: Order.human_attribute_name(:bought_plans), href: bought_plans_path }) 
		end

		if policy(Banner).index?
			menu_links.push({label: Banner.model_name.human(count: 2), href: banners_path }) 
		end

		if policy(Product).index?
			menu_links.push({label: Product.model_name.human(count: 2), href: products_path }) 
		end

		if policy(Service).index?
			menu_links.push({label: Service.model_name.human(count: 2), href: services_path }) 
		end

		if policy(Specialty).index?
			menu_links.push({label: Specialty.model_name.human(count: 2), href: specialties_path }) 
		end

		if policy(SellerCoupon).coupons_to_seller?
			menu_links.push({label: SellerCoupon.human_attribute_name(:coupons_to_seller), href: coupons_to_seller_path}) 
		end

		if policy(SellerCoupon).coupons_to_discount?
			menu_links.push({label: SellerCoupon.human_attribute_name(:coupons_to_discount), href: coupons_to_discount_path}) 
		end

		# if policy(Order).index?
		# 	menu_links.push({label: Order.model_name.human(count: 2), href: orders_path }) 
		# end

		menu_links.push(plans_links)
		menu_links.push(categories_links)

		return menu_links
	end
	
	# Menu de usuários
	def get_users_menu
		result = {}
		submenus = []
		if policy(User).users_admin?
			submenus.push({label: User.human_attribute_name(:admin_users), href: users_admin_path})
		end
		if policy(User).users_user?
			submenus.push({label: User.human_attribute_name(:common_users), href: users_user_path})
		end
		if submenus.length > 0
			result = {label: User.human_attribute_name(:users), submenus: submenus}
		end
		return result
	end
	
	# Menu de endereços
	def get_addresses_menu
		result = {}
		submenus = []
		if policy(Country).index?
			submenus.push({label: Country.model_name.human(count: 2), href: countries_path })
		end
		if policy(State).index?
			submenus.push({label: State.model_name.human(count: 2), href: states_path })
		end
		if policy(City).index?
			submenus.push({label: City.model_name.human(count: 2), href: cities_path })
		end
		if submenus.length > 0
			result = {label: t("menu.address"), submenus: submenus}
		end
		return result
	end

	# Menu de categorias
	def get_categories_menu
		result = {}
		if policy(Category).index?
			submenus = []
			submenus.push({label: Category.human_attribute_name(:services), href: categories_path(category_type_id: CategoryType::SERVICOS_ID) })
			submenus.push({label: Category.human_attribute_name(:products), href: categories_path(category_type_id: CategoryType::PRODUTOS_ID) })
			result = {label: t("menu.categories"), submenus: submenus}
		end
		return result
	end

	# Menu de planos
	def get_plans_menu
		result = {}
		if policy(Plan).index?
			submenus = []
			submenus.push({label: Plan.human_attribute_name(:services), href: plans_path(plan_type_id: PlanType::PARA_SERVICOS_ID) })
			submenus.push({label: Plan.human_attribute_name(:products), href: plans_path(plan_type_id: PlanType::PARA_PRODUTOS_ID) })
			result = {label: t("menu.plans"), submenus: submenus}
		end
		return result
	end

end
