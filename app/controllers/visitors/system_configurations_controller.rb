class Visitors::SystemConfigurationsController < ApplicationController
	skip_before_action :authenticate_user
	
	def show_text
		case params[:text_to_show]
		when SystemConfiguration::POLITICA_USO 
			@text_to_show = @system_configuration.use_policy
			@items_to_show = {
				SystemConfiguration.human_attribute_name(:use_policy) => ''
			}
			@page_name_to_show = SystemConfiguration.human_attribute_name(:use_policy)
		when SystemConfiguration::POLITICA_PRIVACIDADE 
			@text_to_show = @system_configuration.privacy_policy
			@items_to_show = {
				SystemConfiguration.human_attribute_name(:privacy_policy) => ''
			}
			@page_name_to_show = SystemConfiguration.human_attribute_name(:privacy_policy)
		when SystemConfiguration::SOBRE 
			@text_to_show = @system_configuration.about
			@items_to_show = {
				SystemConfiguration.human_attribute_name(:about) => ''
			}
			@page_name_to_show = SystemConfiguration.human_attribute_name(:about)
		when SystemConfiguration::TROCAS_DEVOLUCOES 
			@text_to_show = @system_configuration.exchange_policy
			@items_to_show = {
				SystemConfiguration.human_attribute_name(:exchange_policy) => ''
			}
			@page_name_to_show = SystemConfiguration.human_attribute_name(:about)
		when SystemConfiguration::MINUTA_CONTRATO 
			@text_to_show = @system_configuration.contract_data
			@items_to_show = {
				SystemConfiguration.human_attribute_name(:contract_data) => ''
			}
			@page_name_to_show = SystemConfiguration.human_attribute_name(:contract_data)
		when SystemConfiguration::CONDICOES_GERAIS 
			@text_to_show = @system_configuration.geral_conditions
			@items_to_show = {
				SystemConfiguration.human_attribute_name(:geral_conditions) => ''
			}
			@page_name_to_show = SystemConfiguration.human_attribute_name(:geral_conditions)
		else
			@text_to_show = ''
		end
	end

end