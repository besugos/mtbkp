class NotificationMailer < ApplicationMailer
	
	default from: 'Mercado Topográfico <contato@mercadotopografico.com.br>'

	def forgot_password(user, system_configuration)
		@user = user
		address = @user.email
		if Email.address_valid?(address)
			mail(to: address, subject: t("subject_mails.forgot_password"))
		end
	end

	def welcome(user, system_configuration)
		@user = user
		address = @user.email
		if Email.address_valid?(address)
			mail(to: address, subject: t("subject_mails.welcome"))
		end
	end

	def new_site_contact_user(site_contact, user, system_configuration)
		@site_contact = site_contact
		@user = user
		@system_configuration = system_configuration
		to = @system_configuration.notification_mail
		address = @site_contact.email
		if Rails.env.development?
			to = "andre.sulivam@sulivam.com.br"
		end
		if Email.address_valid?(to)
			mail(reply_to: address, to: to, subject: t("subject_mails.new_site_contact_user")+' - '+site_contact.name)
		end
	end

	def new_site_contact_confirm_message(site_contact, user, system_configuration)
		@site_contact = site_contact
		@user = user
		@system_configuration = system_configuration
		reply_to = @system_configuration.notification_mail
		address = @site_contact.email
		if Rails.env.development?
			address = "andre.sulivam@sulivam.com.br"
		end
		if Email.address_valid?(address)
			mail(to: address, reply_to: reply_to, subject: t("subject_mails.new_site_contact_confirm_message")+' - '+site_contact.name)
		end
	end

	def repproved_professional_document(user, system_configuration)
		@user = user
		@system_configuration = system_configuration
		reply_to = @system_configuration.notification_mail
		address = @user.email
		if Rails.env.development?
			address = "andre.sulivam@sulivam.com.br"
		end
		if Email.address_valid?(address)
			mail(to: address, reply_to: reply_to, subject: t("subject_mails.repproved_professional_document"))
		end
	end

end
