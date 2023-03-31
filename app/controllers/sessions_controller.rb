class SessionsController < ApplicationController

	skip_before_action :authenticate_user

	# Descomentar caso queira timeout de conexão
	# def active
	# 	render_session_status
	# end

	# def timeout
	# 	gflash :error => "Deslogado por inatividade.."
	# 	render_session_timeout
	# end

	def new
		redirect
		@user = User.new(profile_id: Profile::USER_ID)
	end

	def update_locale
		service = Utils::Locale::ChangeLocaleService.new(params[:locale], session)
		result = service.call
		I18n.default_locale = result[1].to_sym
		session[:locale] = result[1]
		redirect_back(fallback_location: :back)
	end

	def create
		if !params[:email].nil? && !params[:email].blank?
			create_by_mail
		elsif !request.env["omniauth.auth"].nil?
			auth = request.env["omniauth.auth"]
			create_by_omniauth(auth)
		else
			redirect_to login_path
		end
	end

	def create_by_mail
		begin
			user = User.active.find_by_email params[:email].strip.downcase
			if user && (user.authenticate(params[:password]) || Rails.env.development?)
				session[:user_id] = user.id
				flash[:success] = t('flash.login')
				if !session[:current_pay_order].nil? && !session[:current_pay_order].blank?
					redirect_pay_order
				else
					redirect
				end
			else
				flash[:error] = t('flash.login_error')
				@user = User.new
				render "new"
			end
		rescue Exception => e
			Rails.logger.error e.message
			redirect_to login_path
		end
	end

	def create_by_omniauth(auth)
		begin
			result = User.find_or_create_from_auth_hash(auth)
			if result[0]
				session[:user_id] = result[1].id
				flash[:success] = t('flash.login')
				redirect
			else
				session[:user_id] = nil
				flash[:error] = result[2]
				redirect_to login_path
			end
		rescue Exception => e
			Rails.logger.error e.message
			redirect_to login_path
		end
	end

	def redirect
		if !session[:user_id].nil?
			logged_user = User.where(:id => session[:user_id]).first
			if !logged_user.nil?
				if session[:current_pay_order].nil?
					redirect_to root_path
				else
					redirect_pay_order
				end
			else
				destroy
			end
		end
	end

	def redirect_pay_order
		current_pay_order = session[:current_pay_order]
		session[:current_pay_order] = nil
		redirect_to pay_order_path(id: current_pay_order)
	end

	def destroy
		session[:user_id] = nil
		flash[:success] = t('flash.logout')
		redirect_to root_path
	end

	def create_user
		@user = User.new(user_params)
		@user.new_user = true
		if @user.save
			# NotificationMailer.welcome(@user, @system_configuration).deliver_later
			flash[:success] = t('flash.create')
			session[:user_id] = @user.id
			redirect_to edit_user_path(@user)
		else
			flash[:error] = @user.errors.full_messages.join('<br>')
			render :new
		end
	end

	def update_current_position
		begin
			if !params[:latitude].nil? && !params[:longitude].nil?
				session[:current_latitude] = params[:latitude]
				session[:current_longitude] = params[:longitude]
			end
			data = true
		rescue Exception => e
			Rails.logger.error "-- update_current_position --"
			Rails.logger.error e.message
			data = false
		end
		respond_to do |format|
			format.json {render :json => data, :status => 200}
		end
	end

private

def user_params
	params
	.require(:user)
	.permit(:id, 
		:name, 
		:email, 
		:password,
		:new_user,
		:phone,
		:accept_therm,
		:password_confirmation, 
		:profile_id)
end
end
