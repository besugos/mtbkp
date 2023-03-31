module ApplicationHelper

	def controller?(*controller)
		controller.include?(params[:controller])
	end

	def action?(*action)
		action.include?(params[:action])
	end

	# Formatando o site para ser redirecionado corretamente
	def format_site_http(link)
		result = ''
		if !link.nil? && !link.blank?
			result = link.gsub('http://', '')
			result = result.gsub('https://','')
			# formato que deve ser colocado no front: "http://#{format_site_http(link)}"
		end
		return result
	end

	# Remove todos os caracteres especiais (máscara) de um telefone
	def format_phone(phone)
		phone.gsub(/[^\d]/, '')
	end

	# Monta uma tag <a> já no formato para telefones
	def tel_to(body, phone, html_options = {})
		phone = 'tel:0' + format_phone(phone)
		link_to(body, phone, html_options)
	end
	
	# Monta uma tag <a> já no formato para e-mails
	def mail_to(body, mail, html_options = {})
		final_mail = 'mailto:' + mail
		link_to(body, final_mail, html_options)
	end

	# Montar uma tag <a> já no formato de abrir o WhatsApp
	def whatsapp_to(body, phone, html_options = {})
		phone = 'https://api.whatsapp.com/send?phone=55' + format_phone(phone)
		link_to(body, phone, html_options)
	end

	# Método para retornar a classe correta para renderizar o
	# "toast" do bootstrap de forma customizada
	def flash_class(level)
		case level
		when 'notice' then "bg-info text-white"
		when 'success' then "bg-success text-white"
		when 'error' then "bg-danger text-white"
		when 'alert' then "bg-warning text-dark"
		end
	end

	# Método para retornar o título correto a ser atribuído ao
	# renderizar o "toast" do bootstrap
	def flash_title(level)
		case level
		when 'notice' then 'Informação'
		when 'success' then 'Sucesso'
		when 'error' then 'Erro'
		when 'alert' then 'Atenção'
		end
	end

	# Retorna uma string sem o final a partir de um determinado caracter
	#
	# Exemplo:
	#  remove_after_char 'https://www.site.com.br/imagem?12345', '?'
	#
	# Vai retornar:
	#  'https://www.site.com.br/imagem'
	def remove_after_char(string, char)

		# Pego o índice que a o caracter está
		char_index = string.index(char)

		# Subtrai 1 para que pegar o íncide a ponto de remover o próprio caracter também seja removido
		char_index = char_index - 1;

		# Retorno a string sem o próprio caracter e tudo que tem para frente
		return string.slice(0..char_index)
	end

	# Convertendo link do youtube para embed
	def youtube_embed(youtube_url)
		begin
			if youtube_url[/youtu\.be\/([^\?]*)/]
				youtube_id = $1
			else
				youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
				youtube_id = $5
			end
			return 'https://www.youtube.com/embed/'+youtube_id
		rescue Exception => e
			return ''
		end
	end

	def get_head_title
		result = t('session.project')
		if !@system_configuration.nil? && !@system_configuration.page_title.blank?
			result = @system_configuration.page_title
		end
		return result
	end

	def get_head_description
		result = t('session.project')
		if !@system_configuration.nil? && !@system_configuration.page_description.blank?
			result = @system_configuration.page_description
		end
		return result
	end

	def get_current_id_google_analytics
		result = ''
		if !@system_configuration.nil? && !@system_configuration.id_google_analytics.blank?
			result = @system_configuration.id_google_analytics
		end
		return result
	end

	# Removendo todos os caracteres especiais de uma string (caracteres e acentuação)
	def removing_special_characters(string)
		result = ''
		if !string.nil? && !string.blank?
			result = I18n.transliterate(string)
		end
		return result
	end

	def show_svg(blob)
		blob.open do |file|
			raw file.read
		end
	end

	def hide_filter?(filter)
		result = false
		if filter.name == :ownertable_type || filter.name == :ownertable_id || filter.name == :address_area_id || filter.name == :page_title
			result = true
		end
		return result
	end

	def show_navigattion_logger_user?
		return (
			!controller?("visitors/home") && 
			!controller?("visitors/system_configurations") && 
			!controller?("visitors/products") && 
			!controller?("visitors/services") && 
			!controller?("visitors/site_contacts") && 
			!action?("show_order_cart") && 
			!action?("pay_order") && 
			!action?("show") && 
			!current_page?('/')
			)
	end

end

# End of file application_helper.rb
# Path: ./app/helpers/application_helper.rb
