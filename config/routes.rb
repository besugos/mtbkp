Rails.application.routes.draw do
	
	# Root path
	root to: 'visitors/home#index'
	get '/update_current_position', :to => 'sessions#update_current_position'

	# Sessions
	get '/sessions', :to => 'sessions#new'
	post '/sessions', :to => 'sessions#create'
	
	# Locale
	get '/update_locale/:locale', :to => 'sessions#update_locale'

	# Login / logout
	get 'login', :to => 'sessions#new', :as => 'login'
	get 'logout', :to => 'sessions#destroy', :as => 'logout'

	# OmniAuth
	post 'login_facebook', to: redirect('/auth/facebook'), as: 'login_facebook'
	post 'login_google', to: redirect('/auth/google_oauth2'), as: 'login_google'
	get 'auth/:provider/callback', to: 'sessions#create'
	get 'auth/failure', to: redirect('/')

	get 'find_cep', :to => 'cep#find_cep', :as => 'find_cep'
	get '/get_card_details', :to => 'cards#get_card_details'

	# Descomentar caso queira timeout da conexão
	# match 'active'  => 'sessions#active',  via: :get
	# match 'timeout' => 'sessions#timeout', via: :get

	# Usuários
	resources :users do
		get 'generate_contract/:user_id', :to => 'users#generate_contract', :as => 'generate_contract'
		member do
			put :block
			get :block
		end
	end
	get '/destroy_profile_image', :to => 'users#destroy_profile_image', :as => 'destroy_profile_image'
	post 'create_user', :to => 'sessions#create_user', :as => 'visitors_create_user'
	get '/send_push_test', :to => 'users#send_push_test', :as => 'send_push_test'
	post '/send_push_to_mobile', :to => 'users#send_push_to_mobile', :as => 'send_push_to_mobile'
	get '/get_addresses_by_seller/:seller_id', :to => 'users#get_addresses_by_seller', :as => 'get_addresses_by_seller'

	# Atualizar dados de acesso
	get '/change_access_data/:id', :to => 'users#change_access_data', :as => 'change_access_data'
	post '/update_access_data/:id', :to => 'users#update_access_data', :as => 'update_access_data'
	
	delete 'delete_phone', :to => 'users#delete_phone', :as => 'delete_phone'
	delete 'delete_email', :to => 'users#delete_email', :as => 'delete_email'
	delete 'delete_attachment', :to => 'users#delete_attachment', :as => 'delete_attachment'
	delete 'delete_data_bank', :to => 'users#delete_data_bank', :as => 'delete_data_bank'
	delete 'delete_card', :to => 'users#delete_card', :as => 'delete_card'
	delete 'delete_address', :to => 'users#delete_address', :as => 'delete_address'
	
	get 'users_admin', :to => 'users#users_admin', :as => 'users_admin'
	get 'users_user', :to => 'users#users_user', :as => 'users_user'

	# Recuperar Senha
	get 'recover_pass', :to => 'users#recovery_pass', :as => 'recovery_pass'
	post 'recover_pass', :to => 'users#create_recovery_pass'
	get 'edit_pass/:recovery_token', :to => 'users#edit_pass', :as => 'edit_pass_token'
	get 'edit_pass', :to => 'users#edit_pass', :as => 'edit_pass'
	patch 'update_pass/:id', :to => 'users#update_pass', :as => 'update_pass'

	# Configurações
	resources :system_configurations, only: [:edit, :update]

	# Produtos
	resources :products
	get 'get_products_values_with_tax', :to => 'products#get_products_values_with_tax', :as => 'get_products_values_with_tax'

	# Ordens de compra
	resources :orders
	get '/show_order_cart', :to => 'orders#show_order_cart', :as => 'show_order_cart'
	get '/add_item_to_order', :to => 'orders#add_item_to_order', :as => 'add_item_to_order'
	delete '/remove_item_to_order/:order_cart_id', :to => 'orders#remove_item_to_order', :as => 'remove_item_to_order'
	get '/add_plan_to_buy', :to => 'orders#add_plan_to_buy', :as => 'add_plan_to_buy'
	get '/sold_products', :to => 'orders#sold_products', :as => 'sold_products'
	get '/bought_plans', :to => 'orders#bought_plans', :as => 'bought_plans'
	get '/my_orders', :to => 'orders#my_orders', :as => 'my_orders'
	
	get '/pay_order', :to => 'orders#pay_order', :as => 'pay_order'
	post '/make_payment', :to => 'orders#make_payment', :as => 'make_payment'
	post 'save_data_to_buy', :to => 'users#save_data_to_buy', :as => 'save_data_to_buy'
	post 'save_address_to_buy', :to => 'orders#save_address_to_buy', :as => 'save_address_to_buy'
	get '/check_payment/:id', :to => 'orders#check_payment', :as => 'check_payment'

	get '/insert_seller_coupon', :to => 'orders#insert_seller_coupon', :as => 'insert_seller_coupon'
	get '/remove_seller_coupon', :to => 'orders#remove_seller_coupon', :as => 'remove_seller_coupon'

	get '/insert_discount_coupon', :to => 'orders#insert_discount_coupon', :as => 'insert_discount_coupon'
	get '/remove_discount_coupon', :to => 'orders#remove_discount_coupon', :as => 'remove_discount_coupon'
	
	get '/get_freight_values', :to => 'orders#get_freight_values', :as => 'get_freight_values'
	get '/updating_freight_select', :to => 'orders#updating_freight_select', :as => 'updating_freight_select'
	post '/update_freight', :to => 'orders#update_freight', :as => 'update_freight'

	get '/chats/:id', :to => 'orders#chats', :as => 'chats'

	post '/request_cancel_order', :to => 'orders#request_cancel_order', :as => 'request_cancel_order'

	# Categorias
	resources :categories
	delete 'delete_sub_category', :to => 'categories#delete_sub_category', :as => 'delete_sub_category'
	get 'get_subcategories/:category_id', :to => 'categories#get_subcategories', :as => 'get_subcategories'
	# Importação
	post 'import_categories', :to => 'categories#import_categories', :as => 'import_categories'
	get 'import_model_categories', :to => 'categories#import_model_categories', :as => 'import_model_categories'
	get 'show_categories_by_category_type/:category_type_id', :to => 'categories#index', :as => 'show_categories_by_category_type'

	# Países
	resources :countries

	# Estados
	resources :states
	get 'countries/:country_id/states.json', :to => 'states#by_country'

	# Cidades
	resources :cities
	get 'states/:state_id/cities.json', :to => 'cities#by_state'

	# Configurações do sistema (visitante)
	get 'show_text/:text_to_show', :to => 'visitors/system_configurations#show_text', :as => 'show_text'

	# Planos
	resources :plans do
		member do
			put :block
			get :block
		end
	end
	get 'show_plans_by_plan_type/:plan_type_id', :to => 'plans#index', :as => 'show_plans_by_plan_type'
	delete 'delete_plan_service', :to => 'plans#delete_plan_service', :as => 'delete_plan_service'

	# FAQs
	resources :faqs

	# Banners
	resources :banners
	post 'active_banner', :to => 'banners#active_banner', :as => 'active_banner'
	delete '/destroy_image_banner', :to => 'banners#destroy_image_banner', :as => 'destroy_image_banner'

	# Depoimentos
	resources :testimonies

	# Contatos do site
	resources :site_contacts
	get 'new_site_contact', :to => 'visitors/site_contacts#new', :as => 'visitors_new_site_contact'
	post 'create_site_contact', :to => 'visitors/site_contacts#create', :as => 'visitors_create_site_contact'

	# Newsletter
	resources :newsletters do
		member do
			put :inactive
			get :inactive
		end
	end
	get 'new_newsletter', :to => 'visitors/newsletters#new', :as => 'visitors_new_newsletter'
	post 'create_newsletter', :to => 'visitors/newsletters#create', :as => 'visitors_create_newsletter'

	resources :services
	resources :teams

  	# Endereços (do usuário)
  	get 'user_addresses', :to => 'users#user_addresses', :as => 'user_addresses'
  	get 'new_user_address', :to => 'users#new_user_address', :as => 'new_user_address'
  	get 'edit_user_address', :to => 'users#edit_user_address', :as => 'edit_user_address'
  	put 'create_user_address', :to => 'users#create_user_address', :as => 'create_user_address'
  	post 'update_user_address', :to => 'users#update_user_address', :as => 'update_user_address'
  	delete 'destroy_user_address', :to => 'users#destroy_user_address', :as => 'destroy_user_address'

  	# Cartões (do usuário)
  	get 'user_cards', :to => 'users#user_cards', :as => 'user_cards'
  	put 'create_user_card', :to => 'users#create_user_card', :as => 'create_user_card'
  	delete 'destroy_user_card', :to => 'users#destroy_user_card', :as => 'destroy_user_card'

  	resources :seller_coupons
  	get 'coupons_to_seller', :to => 'seller_coupons#coupons_to_seller', :as => 'coupons_to_seller'
  	get 'coupons_to_discount', :to => 'seller_coupons#coupons_to_discount', :as => 'coupons_to_discount'

	resources :specialties

	# SITE/HOME
	get 'by_text_filter_products', :to => 'visitors/home#by_text_filter_products', :as => 'by_text_filter_products'
	get 'by_text_filter_services', :to => 'visitors/home#by_text_filter_services', :as => 'by_text_filter_services'
	get 'services_by_all_filters', :to => 'visitors/home#services_by_all_filters', :as => 'services_by_all_filters'

	get 'products_by_category', :to => 'visitors/home#products_by_category', :as => 'products_by_category'
	get 'services_by_category', :to => 'visitors/home#services_by_category', :as => 'services_by_category'

	get '/show_product/:id', :to => 'visitors/products#show_product', :as => 'show_product'
	get '/show_service/:id', :to => 'visitors/services#show_service', :as => 'show_service'

	get 'products_by_professional', :to => 'visitors/home#products_by_professional', :as => 'products_by_professional'
	get 'services_by_professional', :to => 'visitors/home#services_by_professional', :as => 'services_by_professional'
	
	get 'show_professional/:id', :to => 'visitors/home#show_professional', :as => 'show_professional'
	get 'buy_plan', :to => 'visitors/home#buy_plan', :as => 'buy_plan'

	# novas telas
	get 'sold_order_details', :to => 'visitors/home#sold_order_details', :as => 'sold_order_details'
	get 'purchased_order_details', :to => 'visitors/home#purchased_order_details', :as => 'purchased_order_details'
	get 'chat_orders', :to => 'visitors/home#chat_orders', :as => 'chat_orders'

	# Notificação PagSeguro pagamento PIX
	post '/notify_pix_payment', :to => 'payment_transactions#notify_pix_payment', :as => 'notify_pix_payment'
	post '/notify_change_payment', :to => 'payment_transactions#notify_change_payment', :as => 'notify_change_payment'

	get 'cancel_user_plan', :to => 'orders#cancel_user_plan', :as => 'cancel_user_plan'

	post '/update_professional_avaliation', :to => 'orders#update_professional_avaliation', :as => 'update_professional_avaliation'

  end
