class CustomHelper < ApplicationRecord

	# Retorna o texto da data formatado como desejado
	# type = 'date' ou 'datetime'
	# format = :default, :full ou qualquer outro especificado no arquivo de internacionalização
	def self.get_text_date(date, type, format)
		result = ''
		if !date.nil? && !date.blank? && !format.nil?
			if type == 'datetime'
				result = I18n.l date.to_datetime, format: format
			elsif type == 'date'
				result = I18n.l date.to_date, format: format
			end
		end
		return result
	end

	# Retorna o valor como moeda
	# value = valor numérico (0, 10, 23.42, ...)
	def self.to_currency(value)
		result = ''
		if !value.nil?
			result = ActionController::Base.helpers.number_to_currency(value)
		end
		return result
	end
	
	# Retorna o valor como %
	# value = valor numérico (0, 10, 23.42, ...)
	# precision = valor numérico (0, 2, 3)
	def self.to_percentage(value, precision)
		result = ''
		if !value.nil?
			result = ActionController::Base.helpers.number_to_percentage(value, precision: precision)
		end
		return result
	end

	# Retorna o texto "Sim" ou "Não" baseado no parâmetro
	# value = true ou false
	def self.show_text_yes_no(value)
		result = ''
		if !value.nil?
			result = value ? I18n.t('model.yes') : I18n.t('model.no')
		end
		return result
	end

	# Retorna um array para selects com as opções "Sim" e "Não"
	def self.return_select_options_yes_no
		return [[I18n.t("model.yes"), 1],[I18n.t("model.no"), 0]]
	end

	# Retorna um array para selects com as opções "True" e "False"
	def self.return_select_options_true_false
		return [[I18n.t("model.yes"), true],[I18n.t("model.no"), false]]
	end
	
	# Retorna distância entre datas pela unidade desejada (days, years, months, etc)
	def self.distance_of_time_in(unit, from, to)
		begin
			diff = to - from
			if 1.respond_to? unit
				distance = diff / 1.send(unit)
				return distance.to_f
			else
				Rails.logger.error e.message
			end
		rescue Exception => e
			Rails.logger.error e.message
		end
	end

	def self.url_for(object)
		if !object.nil?
			return Rails.application.routes.url_helpers.url_for(object)
		end
	end

	def self.show_svg(blob)
		blob.open do |file|
			raw file.read
		end
	end

	def self.get_clean_text(text)
		result = ""
		if !text.nil? && !text.blank?
			result = text.gsub('.','')
			result = result.gsub(' ','')
			result = result.gsub('-','')
			result = result.gsub('/','')
			result = result.gsub(')','')
			result = result.gsub('(','')
		end
		return result
	end
	
end
