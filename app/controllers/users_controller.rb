class UsersController < ApplicationController
  skip_before_action :authenticate_user, :only => [:recovery_pass, :create_recovery_pass, :edit_pass, :update_pass]

  before_action :set_user, only: [:edit, :update, :destroy, :block, :save_data_to_buy, 
    :change_access_data, :update_access_data, :destroy_profile_image, 
    :user_addresses, :user_cards
  ]

  before_action :set_address, only: [:edit_user_address, :update_user_address, :destroy_user_address]

  def users_admin
    authorize User

    if params[:admins_grid].nil? || params[:admins_grid].blank?
      @users = AdminsGrid.new(:current_user => @current_user)
      @users_to_export = AdminsGrid.new(:current_user => @current_user)
    else
      @users = AdminsGrid.new(params[:admins_grid].merge(current_user: @current_user))
      @users_to_export = AdminsGrid.new(params[:admins_grid].merge(current_user: @current_user))
    end

    if @current_user.admin?
      @users.scope {|scope| scope.page(params[:page]) }
    elsif @current_user.user?
      @users.scope {|scope| scope.page(params[:page]) }
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data @users_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: User.human_attribute_name(:admin_users)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def users_user
    authorize User

    if params[:users_grid].nil? || params[:users_grid].blank?
      @users = UsersGrid.new(:current_user => @current_user)
      @users_to_export = UsersGrid.new(:current_user => @current_user)
    else
      @users = UsersGrid.new(params[:users_grid].merge(current_user: @current_user))
      @users_to_export = UsersGrid.new(params[:users_grid].merge(current_user: @current_user))
    end

    if @current_user.admin?
      @users.scope {|scope| scope.page(params[:page]) }
    elsif @current_user.user?
      @users.scope {|scope| scope.page(params[:page]) }
    end
    
    respond_to do |format|
      format.html
      format.csv do
        send_data @users_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: User.human_attribute_name(:common_users)+" - #{Time.now.to_s}.csv"
      end
    end
    
  end

  def new
    authorize User
    @user = User.new
    @user.profile_id = params[:profile_id]
    build_initials_relations
  end

  def block
    authorize @user

    if @user.is_blocked
      text = User.human_attribute_name(:reactived)
    else
      text = User.human_attribute_name(:inactive)
    end
    if @user.update_column(:is_blocked, !@user.is_blocked)
      flash[:success] = text+I18n.t('model.with_sucess')
    else
      flash[:error] = @user.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def create
    authorize User

    @user = User.new(user_params)
    if @user.save
      save_attachments
      flash[:success] = t('flash.create')
      redirect
    else
      flash[:error] = @user.errors.full_messages.join('<br>')
      build_initials_relations
      render :new
    end
  end

  def edit
    authorize @user
    build_initials_relations
  end

  def update
    authorize @user
    old_professional_document_status_id = nil
    if !@user.data_professional.nil?
      old_professional_document_status_id = @user.data_professional.professional_document_status_id
    end
    @user.skip_validate_password = true
    @user.update(user_params)
    if @user.valid?
      save_attachments
      # Disparando e-mail se foi reprovado
      if !old_professional_document_status_id.nil? && (old_professional_document_status_id != @user.data_professional.professional_document_status_id)
        if @user.data_professional.professional_document_status_id == ProfessionalDocumentStatus::REPROVADO_ID
          NotificationMailer.repproved_professional_document(@user, @system_configuration).deliver_later
        end
      end
      flash[:success] = t('flash.update')
      if @current_user.user?
        redirect_to root_path
      else
        redirect_to edit_user_path(@user)
      end
    else
      flash[:error] = @user.errors.full_messages.join('<br>')      
      build_initials_relations
      render :edit
    end
  end

  def redirect
    if @user.admin?
      redirect_to users_admin_path
    else
      redirect_to users_user_path
    end
  end

  def change_access_data
    authorize @user
  end

  def update_access_data
    authorize @user
    valid = false
    if !user_params[:current_password].nil? || !user_params[:current_password].blank?
      if @user.authenticate(user_params[:current_password])
        @user.update(user_params)
        if @user.valid?
          valid = true
        else
          message = @user.errors.full_messages.join('<br>')
        end
      else
        message = User.human_attribute_name(:wrong_current_password)
        flash[:error] = User.human_attribute_name(:wrong_current_password)
      end
    else
      message = User.human_attribute_name(:wrong_current_password)
      flash[:error] = User.human_attribute_name(:wrong_current_password)
    end
    if valid
      flash[:success] = t('flash.update')
      redirect_to edit_user_path(@user.id)
    else
      flash[:error] = message
      render :change_access_data
    end
  end

  def build_initials_relations
    if @user.phones.select{ |item| item[:id].nil? }.length == 0
      @user.phones.build
    end
    if @user.emails.select{ |item| item[:id].nil? }.length == 0
      @user.emails.build
    end
    if @user.data_banks.select{ |item| item[:id].nil? }.length == 0
      @user.data_banks.build
    end
    if @user.cards.select{ |item| item[:id].nil? }.length == 0
      @user.cards.build
    end
    if @user.addresses.select{ |item| item[:id].nil? }.length == 0
      @user.addresses.build(address_area_id: AddressArea::GENERAL_ID)
    end
    if @user.attachments.select{ |item| item[:id].nil? }.length == 0
      @user.attachments.build
    end
    @user.build_address(address_area_id: AddressArea::GENERAL_ID) if @user.address.nil?
    @user.build_attachment if @user.attachment.nil?
    @user.build_data_professional if @user.data_professional.nil?

    @user.data_professional.build_address if @user.data_professional.address.nil?
  end

  def destroy
    authorize @user
    if @user.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @user.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def save_attachments
    if !user_params[:data_professional_attributes].nil? && !user_params[:data_professional_attributes][:files].nil?
      user_params[:data_professional_attributes][:files].each do |file|      
        @user.data_professional.attachments.create(:attachment => file)
      end
    end
  end

  def destroy_profile_image
    authorize @user
    @user.profile_image.purge
    result = true
    data = {
      result: result
    }
    respond_to do |format|
      format.html 
      format.json {render :json => data, :status => 200}
    end
  end

  def get_addresses_by_seller
    addresses = Address.by_ownertable_type("User")
    .by_ownertable_id(params[:seller_id])
    .by_address_area_id(AddressArea::ENDERECO_SAIDA_ID)
    data = {
      result: addresses
    }
    respond_to do |format|
      format.html 
      format.json {render :json => data, :status => 200}
    end
  end
  
  def generate_contract
    authorize User
    doc_replace = DocxReplace::Doc.new("#{Rails.root}/app/contracts/contrato_exemplo.docx", "#{Rails.root}/tmp")

    # Formata os caracteres do documento para conseguir substituir
    FormatDocWordToReplace.word_xml_gsub!(doc_replace.instance_variable_get(:@document_content), '$nome_cliente$', @current_user.name)
    FormatDocWordToReplace.word_xml_gsub!(doc_replace.instance_variable_get(:@document_content), '$numero_contrato$', @current_user.id.to_s)
    
    tmp_file = Tempfile.new('word_tempate', "#{Rails.root}/tmp")
    doc_replace.commit(tmp_file.path)
    send_file tmp_file.path, filename: "user_#{@current_user.id}_contract.docx", disposition: 'attachment'
  end

  def recovery_pass
  end

  def create_recovery_pass
    user = User.active.find_by_email(recover_params)
    if user
      user.update_column(:recovery_token, SecureRandom.urlsafe_base64)
      NotificationMailer.forgot_password(user, @system_configuration).deliver_later
      flash[:success] = t('flash.change_password')
      redirect_to login_path
    else
      flash[:error] = t('flash.change_password_error')
      render 'recovery_pass'
    end
  end

  def edit_pass
    if params[:recovery_token]
      session[:user_id] = nil
      @user = User.find_by_recovery_token params[:recovery_token]
    end

    @user = current_user if current_user

    if !@user
      flash[:error] = t('flash.change_password_error')
      redirect_to login_path
    end
  end

  def update_pass
    @user = User.active.find(params[:id])
    if user_params[:password].nil? || user_params[:password].blank?
      flash[:error] = User.human_attribute_name(:invalid_password)
      redirect_back(fallback_location: :back)
    else
      if @user.update(user_params)
        session[:user_id] = @user.id
        @user.update_columns(recovery_token: nil)
        flash[:success] = t('flash.update')
        redirect_to edit_user_path(@user)
      else
        flash[:error] = @user.errors.full_messages.join('<br>')
        redirect_back(fallback_location: :back)
      end
    end
  end

  def delete_address
    address = Address.where(id: params[:model_id]).first
    if address
      address.destroy
      flash[:success] = t('flash.destroy')
      redirect_back(fallback_location: :back)
    else
      redirect_to edit_user_path(@current_user)
    end
  end

  def delete_phone
    phone = Phone.where(id: params[:model_id]).first
    if phone
      phone.destroy
      flash[:success] = t('flash.destroy')
      redirect_back(fallback_location: :back)
    else
      redirect_to edit_user_path(@current_user)
    end
  end

  def delete_email
    email = Email.where(id: params[:model_id]).first
    if email
      email.destroy
      flash[:success] = t('flash.destroy')
      redirect_back(fallback_location: :back)
    else
      redirect_to edit_user_path(@current_user)
    end
  end

  def delete_attachment
    attachment = Attachment.where(id: params[:model_id]).first
    if attachment
      attachment.destroy
      flash[:success] = t('flash.destroy')
      redirect_back(fallback_location: :back)
    else
      redirect_to edit_user_path(@current_user)
    end
  end

  def delete_data_bank
    data_bank = DataBank.where(id: params[:model_id]).first
    if data_bank
      data_bank.destroy
      flash[:success] = t('flash.destroy')
      redirect_back(fallback_location: :back)
    else
      redirect_to edit_user_path(@current_user)
    end
  end

  def delete_card
    card = Card.where(id: params[:model_id]).first
    if card
      card.destroy
      flash[:success] = t('flash.destroy')
      redirect_back(fallback_location: :back)
    else
      redirect_to edit_user_path(@current_user)
    end
  end

  def save_data_to_buy
    define_current_order
    @user.skip_validate_password = true
    @user.update(user_params)
    if @user.valid?
      flash[:success] = Order.human_attribute_name(:data_saved)
      if !@current_order.is_address_valid? || !params[:show_address_data].nil?
        redirect_to pay_order_path(id: @current_order.id, show_address_data: true)
      else
        redirect_to pay_order_path(id: @current_order.id)
      end
    else
      flash[:error] = @user.errors.full_messages.join('<br>')
      render 'users/pay_order'
    end
  end

  def define_current_order
    if !params[:current_order_id].nil? && !params[:current_order_id].blank?
      @current_order = Order.where(id: params[:current_order_id]).first
      if @current_order.user.nil? && !@current_user.nil?
        @current_order.update_columns(user_id: @current_user.id)
      end
    else
      if @current_user.nil?
        @order.save!
        @current_order = @order
      elsif !session[:current_order_id].nil?
        @current_order = Order.where(id: session[:current_order_id]).first
      else
        @order.user_id = @current_user.id
        @order.save!
        @current_order = @order
      end
    end
  end

  def send_push_test
    authorize User
  end

  def send_push_to_mobile
    authorize User
    data = {
      foo: "bar"
    }
    if params[:service] == "Firebase"
      service = Utils::PushNotification::DispareNotificationService.new(params[:title], params[:message], [params[:mobile_code]], data)
      puts service.call
    else
      name = params[:message]
      include_player_ids = [
        params[:mobile_code]
      ]
      headings = {
        pt: params[:title],
        en: params[:title]
      }
      contents = {
        pt: params[:message],
        en: params[:message]
      }
      service = Utils::OneSignal::CreateNotificationService.new(name, include_player_ids, data, headings, contents)
      puts service.call
    end
    redirect_back(fallback_location: :back)
  end

  def user_addresses
    if @current_user.user?
      @user = @current_user
    elsif @user.nil? && !params[:addresses_grid][:ownertable_id].nil?
      @user = User.where(id: params[:addresses_grid][:ownertable_id]).first
    end
    authorize @user

    if params[:addresses_grid].nil? || params[:addresses_grid].blank?
      @addresses = AddressesGrid.new(current_user: @current_user, 
        ownertable_type: params[:ownertable_type], 
        ownertable_id: params[:ownertable_id], 
        address_area_id: params[:address_area_id],
        page_title: params[:page_title])
    else
      @addresses = AddressesGrid.new(params[:addresses_grid].merge(current_user: @current_user, 
        ownertable_type: params[:ownertable_type], 
        ownertable_id: params[:ownertable_id], 
        address_area_id: params[:address_area_id],
        page_title: params[:page_title]))
    end

    define_variables

    if @current_user.admin?
      @addresses.scope {
        |scope| scope
        .by_ownertable_type("User")
        .by_ownertable_id(params[:id])
        .by_address_area_id(params[:address_area_id])
        .page(params[:page]) 
      }
    elsif @current_user.user?
      @addresses.scope {
        |scope| scope
        .by_ownertable_type("User")
        .by_ownertable_id(@current_user.id)
        .by_address_area_id(params[:address_area_id])
        .page(params[:page]) 
      }
    end
    
    respond_to do |format|
      format.html
    end
  end

  def define_variables
    @ownertable_type = ""
    @ownertable_id = ""
    @address_area_id = ""
    @page_title = ""

    if !params[:ownertable_type].nil?
      @ownertable_type = params[:ownertable_type]
      @ownertable_id = params[:id]
      @address_area_id = params[:address_area_id]
      @page_title = params[:page_title]
    elsif !params[:addresses_grid][:ownertable_type].nil?
      @ownertable_type = params[:addresses_grid][:ownertable_type]
      @ownertable_id = params[:addresses_grid][:ownertable_id]
      @address_area_id = params[:addresses_grid][:address_area_id]
      @page_title = params[:addresses_grid][:page_title]
    end
  end

  def new_user_address
    @user = User.find(params[:ownertable_id])
    authorize @user
    @address = Address.new(ownertable_type: params[:ownertable_type], ownertable_id: params[:ownertable_id], address_area_id: params[:address_area_id], page_title: params[:page_title])
    @page_title = params[:page_title]
  end

  def edit_user_address
    if policy(@address.ownertable).edit_user_address?(@address)
      @address.page_title = params[:page_title]
      @page_title = params[:page_title]
    else
      user_not_authorized
    end
  end

  def create_user_address
    @user = User.where(id: address_params[:ownertable_id]).first
    authorize @user
    @address = Address.new(address_params)
    if @address.save
      Address.getting_latitude_longitude(@address)
      flash[:success] = t('flash.create')
      redirect_to user_addresses_path(ownertable_type: @address.ownertable_type, ownertable_id: @address.ownertable_id, address_area_id: @address.address_area_id, page_title: @address.page_title)
    else
      flash[:error] = @address.errors.full_messages.join('<br>')
      @page_title = @address.page_title
      render :new_user_address
    end
  end

  def update_user_address
    if policy(@address.ownertable).update_user_address?(@address)
      @address.update(address_params)
      if @address.valid?
        Address.getting_latitude_longitude(@address)
        flash[:success] = t('flash.update')
        redirect_to user_addresses_path(ownertable_type: @address.ownertable_type, ownertable_id: @address.ownertable_id, address_area_id: @address.address_area_id, page_title: @address.page_title)
      else
        flash[:error] = @address.errors.full_messages.join('<br>')
        @page_title = @address.page_title
        render :edit_user_address
      end
    else
      user_not_authorized
    end
  end

  def destroy_user_address
    if policy(@address.ownertable).destroy_user_address?(@address)
      if @address.destroy
        flash[:success] = t('flash.destroy')
      else
        flash[:error] = @address.errors.full_messages.join('<br>')
      end
      redirect_back(fallback_location: :back)
    else
      user_not_authorized
    end
  end

  def user_cards
    authorize @user

    if params[:cards_grid].nil? || params[:cards_grid].blank?
      @cards = CardsGrid.new(current_user: @current_user, 
        ownertable_type: params[:ownertable_type], 
        ownertable_id: params[:id], 
        page_title: params[:page_title])
    else
      @cards = CardsGrid.new(params[:cards_grid].merge(current_user: @current_user, 
        ownertable_type: params[:ownertable_type], 
        ownertable_id: params[:id], 
        page_title: params[:page_title]))
    end

    define_variables_cards

    @card = Card.new(ownertable_type: params[:ownertable_type], ownertable_id: params[:id], page_title: params[:page_title])

    if @current_user.admin?
      @cards.scope {
        |scope| scope
        .by_ownertable_type("User")
        .by_ownertable_id(params[:id])
        .page(params[:page]) 
      }
    elsif @current_user.user?
      @cards.scope {
        |scope| scope
        .by_ownertable_type("User")
        .by_ownertable_id(@current_user.id)
        .page(params[:page]) 
      }
    end
    
    respond_to do |format|
      format.html
    end
  end

  def define_variables_cards
    @ownertable_type = ""
    @ownertable_id = ""
    @page_title = ""

    if !params[:ownertable_type].nil?
      @ownertable_type = params[:ownertable_type]
      @ownertable_id = params[:id]
      @page_title = params[:page_title]
    elsif !@card.ownertable_type.nil?
      @ownertable_type = @card.ownertable_type
      @ownertable_id = @card.ownertable_id
      @page_title = @card.page_title
    end
  end

  def create_user_card
    @user = User.where(id: card_params[:ownertable_id]).first
    authorize @user
    @card = Card.new(card_params)
    if @card.save
      flash[:success] = t('flash.create')
      redirect_to user_cards_path(ownertable_type: @card.ownertable_type, id: @card.ownertable_id, page_title: Card.model_name.human(count: 2))
    else
      flash[:error] = @card.errors.full_messages.join('<br>')
      redirect_to user_cards_path(ownertable_type: @card.ownertable_type, id: @card.ownertable_id, page_title: @card.page_title)
    end
  end

  def destroy_user_card
    authorize @card.ownertable
    if @card.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @card.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def set_address
    @address = Address.find_by_id(params[:id])
  end

  def recover_params
    params.require(:recovery_pass).permit(:email)[:email]
  end

  def user_params
    params
    .require(:user)
    .permit(:id, :name, :email, :access_user, :password, :password_confirmation, :recovery_token, 
      :profile_id, :is_blocked, :phone, :cpf, :rg, :birthday, 
      :social_name, :fantasy_name, :cnpj, :person_type_id, :sex_id, :profile_image, :current_password,
      :cellphone, :profession, :civil_state_id, :accept_therm,
      :seller_verified, :publish_professional_profile, :description, 
      :work_experience, :deadline_avaliation, :quality_avaliation, :problems_solution_avaliation,
      :icms_contribution_id,
      phones_attributes: [:id, :is_whatsapp, :phone_code, :phone, :phone_type_id, :responsible],
      emails_attributes: [:id, :email, :email_type_id],
      attachment_attributes: [:id, :attachment, :attachment_type],
      attachments_attributes: [:id, :attachment, :attachment_type],
      data_banks_attributes: [:id, :bank_id, :data_bank_type_id, :bank_number, :agency, :account, :operation, :assignor, :cpf_cnpj, :pix],
      data_bank_attributes: [:id, :bank_id, :data_bank_type_id, :bank_number, :agency, :account, :operation, :assignor, :cpf_cnpj, :pix],
      cards_attributes: [:id, :principal, :card_banner_id, :nickname, :name, :number, :ccv_code, :validate_date_month, :validate_date_year],
      address_attributes: [:id, :latitude, :longitude, :page_title, :address_type_id, :address_area_id, :name, :zipcode, :address, :district, :number, :complement, :address_type, :state_id, :city_id, :country_id, :reference],
      addresses_attributes: [:id, :latitude, :longitude, :page_title, :address_type_id, :address_area_id, :name, :zipcode, :address, :district, :number, :complement, :address_type, :state_id, :city_id, :country_id, :reference],
      data_professional_attributes: [:id, :user_id, :professional_document_status_id, :email, 
        :phone, :site, :profession, :register_type, :register_number, :repprovation_reason,
        files: [],
        attachments_attributes: [:id, :attachment],
        address_attributes: [:id, :latitude, :longitude, :ownertable_type, :ownertable_id, :page_title, :address_type_id, :address_area_id, :name, :zipcode, :address, :district, :number, :complement, :address_type, :state_id, :city_id, :country_id, :reference],
        specialty_ids: []
      ]
      )
  end

  def address_params
    params
    .require(:address)
    .permit(:id, :ownertable_type, :page_title, :ownertable_id,
      :address_type_id, :address_area_id, 
      :name, :zipcode, :address, :district, :number, 
      :complement, :address_type, :state_id, 
      :city_id, :country_id, :reference)
  end

  def card_params
    params
    .require(:card)
    .permit(:id, :ownertable_type, :ownertable_id,
      :principal, :card_banner_id, :nickname, :name, :page_title,
      :number, :ccv_code, :validate_date_month, :validate_date_year)
  end

end
