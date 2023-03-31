class User < ActiveRecord::Base
	acts_as_reader
	paginates_per 24
	after_initialize :default_values
	before_validation :insert_profile_image

	ADMIN_FIRST_ID = 1

	default_scope {includes(:profile)}

	attr_accessor :skip_validate_password, :seed, :edit_pass, :profile_image_url, :new_user, :current_password

	belongs_to :profile
	belongs_to :person_type
	belongs_to :sex
	belongs_to :payment_type
	belongs_to :civil_state
	belongs_to :icms_contribution

	has_many :messages, dependent: :destroy, foreign_key: :sender_id
	has_many :messages, dependent: :destroy, foreign_key: :receiver_id

	has_many :my_avaliations, 
	join_table: :professional_avaliations, 
	dependent: :destroy, 
	foreign_key: :professional_id, class_name: "ProfessionalAvaliation"

	has_many :professional_avaliations, dependent: :destroy

	has_one :attachment, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :attachment

	has_one :address, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :address

	has_many :addresses, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :addresses, :reject_if => :all_blank

	has_many :attachments, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :attachments, :reject_if => :all_blank

	has_many :phones, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :phones, :reject_if => proc { |attrs| attrs[:phone].blank? }

	has_many :emails, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :emails, :reject_if  => proc { |attrs| attrs[:email].blank? }

	has_many :data_banks, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :data_banks, :reject_if => :all_blank

	has_one :data_bank, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :data_bank, :reject_if => :all_blank

	has_many :cards, as: :ownertable, validate: false, dependent: :destroy
	accepts_nested_attributes_for :cards, :reject_if => proc { |attrs| attrs[:number].blank? }

	has_many :orders, validate: false, dependent: :destroy
	accepts_nested_attributes_for :orders

	has_one :data_professional, dependent: :destroy
	accepts_nested_attributes_for :data_professional

	has_and_belongs_to_many :seller_coupons, dependent: :destroy

	has_many :products, dependent: :destroy
	has_many :services, dependent: :destroy
	
	has_many :user_plans, dependent: :destroy

	# <%= collection_check_boxes(:user, :example_ids, Example.order(:name), :id, :name) do |b| %>
	# <div class="col-12 mt-2">
	#     <%= b.label do %>
	#             <%= b.check_box(class: "") %>
	#             <%= b.text(class: "") %>
	#     <% end %>
	# </div>
	# <% end %>
	# has_and_belongs_to_many :examples

		# <label><%= Offer.human_attribute_name(:offer_color_id) %></label>
	 #    <%= collection_radio_buttons(:offer, :offer_color_id, OfferColor.all, :id, :name) do |b| %>
	 #        <div class="col-12 mt-2" style="background-color: <%= b.object.color %>;">
	 #            <%= b.label do %>
	 #                <%= b.radio_button(class: "") %>
	 #                <span style="color: <%= b.object.background_color %>"><%= b.text %></span>
	 #            <% end %>
	 #        </div>
	 #    <% end %>
	# belongs_to :example

	has_secure_password
	validates_presence_of :password, if: Proc.new { |user| user.skip_validate_password != true && !user.persisted?}
	
	validates_presence_of :profile_id, 
	:name,
	:email,
	:phone

	validate :name_is_less_than_2, if: Proc.new { |user| user.seed != true }

	# Exemplo self relation
	# belongs_to :parent, :class_name => 'Menu'
  	# has_many :menus, class_name: "Menu", foreign_key: "parent_id"

  	# Exemplo de policy fora da view/controller
  	# Pundit.policy(current_user, object).method?

	validates_acceptance_of :accept_therm, accept: true, if: Proc.new { |user| user.profile_id == Profile::USER_ID && user.seed != true && user.seed != 'true'}

	has_one_attached :profile_image

	# has_attached_file :profile_image,
	# :storage => :s3,
	# :url => ":s3_domain_url",
	# styles: { medium: "300x300#", thumb: "100x100#" },
	# :path => ":class/profile_image/:id_partition/:style/:filename"
	# do_not_validate_attachment_file_type :profile_image

	# validate :validate_age
	# validate :validate_cpf
	
	# Validações de e-mail
	validates_email_format_of :email, :message => I18n.t('model.invalid'), if: Proc.new { |user| user.seed != true && user.seed != 'true' && !user.email.blank?}
	# validates :email, 'valid_email_2/email': { mx: true }, if: Proc.new { |user| user.seed != true && user.seed != 'true' && !user.email.blank?}
	validates_uniqueness_of :email, :case_sensitive => false

	# Para situações de domínios customizados (arquivo whitelisted_email_domains.yml)
	# validates :email, 'valid_email_2/email': { disposable_domain_with_whitelist: true }, if: Proc.new { |user| user.seed != true && user.seed != 'true' && !user.email.blank?}

	# Criando usuário pelo retorno da autenticação social
	def self.find_or_create_from_auth_hash(auth)
		begin
			user = User.where(provider: auth.provider, uid: auth.uid).first
			if user.nil?
				user = User.find_by_email(auth.info.email)
				if user.nil?
					user = User.new
				end
			end
			if user.profile_id.nil?
				password = SecureRandom.urlsafe_base64
				user.profile_id = Profile::USER_ID
				user.password = password
				user.password_confirmation = password
			end
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.email = auth.info.email
			user.skip_validate_password = true
			user.save
			return [user.valid?, user, user.errors.full_messages.join('<br>')]
		rescue Exception => e
			Rails.logger.error e.message
			return [false, nil, e.message]
		end
	end

	scope :active, -> { where(is_blocked: false) }

	scope :admin, -> do
		where(profile_id: Profile::ADMIN_ID)
	end

	scope :user, -> do
		where(profile_id: Profile::USER_ID)
	end

	scope :is_professional_validated, -> { 
		joins(:data_professional)
		.where(publish_professional_profile: true, seller_verified: true) 
		.where(data_professional: {professional_document_status_id: ProfessionalDocumentStatus::VALIDADO_ID})
	}

	scope :by_id, lambda { |value| where("users.id = ?", value) if !value.nil? && !value.blank? }

	scope :by_profile_id, lambda { |value| where(profile_id: value) if !value.nil? && !value.blank? }

	scope :by_person_type_id, lambda { |value| where(person_type_id: value) if !value.nil? && !value.blank? }
	
	scope :by_civil_state_id, lambda { |value| where(civil_state_id: value) if !value.nil? && !value.blank? }
	
	scope :by_professional_document_status_id, lambda { |value| joins(:data_professional).where("data_professionals.professional_document_status_id = ?", value) if !value.nil? && !value.blank? }
	
	scope :by_product_plan_id, lambda { |value| joins(:data_professional).where("data_professionals.product_plan_id = ?", value) if !value.nil? && !value.blank? }
	
	scope :by_service_plan_id, lambda { |value| joins(:data_professional).where("data_professionals.service_plan_id = ?", value) if !value.nil? && !value.blank? }

	scope :by_is_blocked, lambda { |value| where(is_blocked: value) if !value.nil? && !value.blank? }
	
	scope :by_publish_professional_profile, lambda { |value| where(publish_professional_profile: value) if !value.nil? && !value.blank? }

	scope :by_name, lambda { |value| where("LOWER(users.name) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }

	scope :by_email, lambda { |value| where("LOWER(users.email) LIKE ?", "%#{value.downcase}%") if !value.nil? && !value.blank? }

	scope :by_cpf_cnpj, lambda { |value| where("users.cpf LIKE ? or users.cnpj LIKE ?", "%#{value}%", "%#{value}%") if !value.nil? && !value.blank? }

	scope :by_initial_date, lambda { |value| where("created_at >= '#{value} 00:00:00'") if !value.nil? && !value.blank? }
	scope :by_final_date, lambda { |value| where("created_at <= '#{value} 23:59:59'") if !value.nil? && !value.blank? }

	scope :can_chat, -> do
		where.not(id: 1)
	end

	# Usuário é administrador?
	def admin?
		!profile.nil? && profile.admin?
	end

	# Usuário é usuário comum?
	def user?
		!profile.nil? && profile.user?
	end

	def text_blocked
		if self.is_blocked
			return User.human_attribute_name(:set_active)
		end
		return User.human_attribute_name(:set_inactive)
	end

	def get_is_blocked?
		return (self.is_blocked ? User.human_attribute_name(:inactive) : User.human_attribute_name(:active))
	end

	def get_birthday
		return CustomHelper.get_text_date(self.birthday, 'date', :default)
	end

	def get_name
		if self.person_type_id == PersonType::FISICA_ID
			return self.name
		elsif self.person_type_id == PersonType::JURIDICA_ID
			return self.fantasy_name
		end
		return ''
	end

	def get_formatted_text_to_select
		return "#"+self.id.to_s+" - "+self.name
	end

	def get_document
		if self.person_type_id == PersonType::FISICA_ID
			return self.cpf
		elsif self.person_type_id == PersonType::JURIDICA_ID
			return self.cnpj
		end
		return ''
	end

	def get_first_phone
		result = nil
		if self.phones.length > 0
			result = self.phones.first
		end
		return result
	end

	def self.get_profile_image_url(user)
		result = "https://via.placeholder.com/150"
		if user.profile_image.attached?
			result = user.profile_image.url
		end
		return result
	end

	def get_name_chat
		result = ""
		result = self.name
		return result
	end

	def get_first_phone_phone
		result = ''
		phone = get_first_phone
		if !phone.nil? && !phone.phone.nil?
			result = phone.phone.gsub('.','')
			result = result.gsub(' ','')
			result = result.gsub('-','')
			result = result.gsub('/','')
		end
		return result
	end

	def is_valid_to_buy?
		return (!self.name.nil? && !self.name.blank?) && (!self.cpf.nil? && !self.cpf.blank? && self.cpf.gsub(/[.,-]/, "").length > 0)
	end

	def get_document_clean
		return clean_text(self.cpf)
	end

	def clean_text(text)
		result = text.gsub('.','')
		result = result.gsub(' ','')
		result = result.gsub('-','')
		result = result.gsub('/','')
		return result
	end

	def get_average_avaliation
		sum = 0
		professional_avaliations = self.my_avaliations
		sum += professional_avaliations.inject(0){|sum,x| sum + x.deadline_avaliation}
		sum += professional_avaliations.inject(0){|sum,x| sum + x.quality_avaliation}
		sum += professional_avaliations.inject(0){|sum,x| sum + x.problems_solution_avaliation}
		sum = (sum/3)
		return sum
	end

	def is_valid_to_buy_plan?
		result = false
		if self.publish_professional_profile && !self.data_professional.nil? && self.data_professional.professional_document_status_id == ProfessionalDocumentStatus::VALIDADO_ID
			result = true
		end
		return result
	end

	def self.getting_last_user_plan(professional, plan_type)
		result = nil
		current_plan = nil
		user_plan = nil
		data_professional = professional.data_professional
		if plan_type == PlanType::PRODUTOS_NAME
			current_plan = professional.data_professional.product_plan unless professional.data_professional.product_plan.nil?
		else
			current_plan = professional.data_professional.service_plan unless professional.data_professional.service_plan.nil?
		end
		if !current_plan.nil?
			result = professional.user_plans.select{|item| item.plan_id == current_plan.id}.last
		end
		return result
	end
	
	def self.mark_all_as_read(receiver, sender)
		begin
			messages = Message.where(sender_id: sender.id, receiver_id: receiver.id).unread(receiver)
			messages.each do |message|
				Rails.logger.info message.mark_as_read! for: receiver
			end
			User.sending_notification_to_user(receiver.id)
		rescue Exception => e
			Rails.logger.error e.message
			Rails.logger.error "-- mark_all_as_read --"
		end
	end

	def self.sending_notification_to_user(receiver_id)
		begin
			url_helper = Rails.application.routes.url_helpers

			current_user = User.where(id: receiver_id).first
			unread_chats = Message.where(receiver_id: current_user.id)
			.unread(current_user)

			unread_chats_group = unread_chats.group(:sender_id)

			unread_messages = []
			unread_users = User.where(id: unread_chats_group.map(&:sender_id))

			unread_users.each do |user|
				last_message = Message
				.where("(receiver_id = ? AND sender_id = ?) OR (receiver_id = ? AND sender_id = ?)", user.id, current_user.id, current_user.id, user.id)
				.last

				user_messages = {
					# link_chat: url_helper.chats_path(id: user_id: user.id),
					image_url: User.get_profile_image_url(user),
					user_id: user.id,
					user_name: user.get_name_chat.truncate(30),
					unread_messages: unread_chats.select{|item| item.sender_id == user.id}.length,
					last_message: last_message,
					last_message_date: (last_message.created_at unless last_message.nil?),
					last_message_date_formatted: (CustomHelper.get_text_date(last_message.created_at, "datetime", :full) unless last_message.nil?)
				}
				unread_messages.push(user_messages)
			end

			data = {
				receiver_id: receiver_id,
				unread_chats: unread_chats_group.length,
				unread_messages: unread_messages
			}
			ActionCable.server.broadcast "general_channel##{receiver_id}", data: data
		rescue Exception => e
			Rails.logger.error e.message
			Rails.logger.error "-- sending_notification_to_user --"
		end
	end

	def self.generate_data_to_melhor_envio(user, address)
		result = {}
		begin
			if !user.nil? && !address.nil?
				document_clean = CustomHelper.get_clean_text(user.cpf)
				result = {
					name: user.name,
					phone: CustomHelper.get_clean_text(user.phone),
					email: user.email,
					document: (CPF.valid?(user.cpf) ? document_clean : ""),
					company_document: (CNPJ.valid?(user.cpf) ? document_clean : ""),
					address: address.address,
					complement: address.complement,
					number: address.number,
					district: address.district,
					city: (address.city.name unless address.city.nil?),
					country_id: "BR",
					postal_code: CustomHelper.get_clean_text(address.zipcode)
				}
			end
		rescue Exception => e
			Rails.logger.error e.message
			Rails.logger.error "-- generate_data_to_melhor_envio --"
		end
		return result
	end

	private

	def default_values
		self.name ||= ''
		self.cellphone ||= ''
		self.profession ||= ''

		self.person_type_id ||= PersonType::FISICA_ID
		self.sex_id ||= Sex::MASCULINO_ID
		self.payment_type_id ||= PaymentType::CARTAO_CREDITO_ID

		self.accept_therm ||= false if self.accept_therm.nil?
		self.icms_contribution_id ||= IcmsContribution::NAO_ID
	end

	def validate_cpf
		require "cpf_cnpj"
		if !self.admin? && !CPF.valid?(self.cpf)
			errors.add(:cpf, I18n.t('model.invalid'))
		end
	end

	def insert_profile_image
		if !self.profile_image_url.nil? && !self.profile_image_url.blank?
			require 'uri'
			if self.profile_image_url =~ URI::regexp
				self.profile_image = URI.parse(self.profile_image_url).open
			end
		end
	end

	# def validate_cnpj
	# 	if !CNPJ.valid?(self.cnpj)
	# 		errors.add(:cnpj, "inválido")
	# 	end
	# end

	# Validando se o nome possui ao menos 2 palavras
	def name_is_less_than_2
		errors[:name] << "inválido" if name.split.size < 2
	end

	# Maior de 18 anos
	def validate_age
		if birthday.present? && birthday > 18.years.ago.to_date
			errors.add(:birthday, 'deve ser maior de 18 anos')
		end
	end

end
