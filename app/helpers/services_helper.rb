module ServicesHelper
	def get_service_message_to_whatsapp(service)
		url_helper = Rails.application.routes.url_helpers

		message = "Olá! Estou vindo pelo Mercado Topográfico e gostaria de um orçamento "
		url_helper = Rails.application.routes.url_helpers
		link = url_helper.show_service_url(id: service.id)
		message += link

		return message
	end
	
	def get_service_message_to_whatsapp_cancel_plan
		message = "Olá! Quero cancelar o meu plano no MT."
		return message
	end
end
