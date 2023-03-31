require 'rufus-scheduler'

ENV['TZ'] = 'America/Sao_Paulo'

# Se necessitar de garantir apenas 1 execução por vez (necessário no servidor criar o arquivo .rufus-scheduler.lock na raiz do projeto e dar permissão de escrita)
# s = Rufus::Scheduler.singleton(lockfile: '.rufus-scheduler.lock')

s = Rufus::Scheduler.singleton(lockfile: ".rufus-scheduler.lock")

unless s.down?
	s.cron '00 03 * * *', :first_in => 5 do
		if Rails.env.production?
			UserPlan.routine_payments
			Service.routine_inactive_services
			FreightOrderOption.routine_update_freight_order_status

			@system_configuration = SystemConfiguration.first
			if (Date.today + 10.days) > @system_configuration.melhor_envio_expires_date
				refresh_token = @system_configuration.melhor_envio_refresh_token
				# Gerar novo access e refresh token
				service = Utils::MelhorEnvio::RefreshTokenService.new(refresh_token)
				transaction = service.call
				if transaction[0]
					new_access_token = transaction[2]["access_token"]
					new_refresh_token = transaction[2]["refresh_token"]
					new_expires_data = Date.today + 30.days
					@system_configuration.update_columns(melhor_envio_access_token: new_access_token, melhor_envio_refresh_token: new_refresh_token, melhor_envio_expires_date: new_expires_data)
				end
			end
		end
	end

	s.cron '00 08 * * *' do
	end

	s.every '1h', :first_in => 5 do
		if Rails.env.production?
			FreightOrderOption.routine_update_freight_order_status
		end
	end

	s.every '1h', :first_in => 5 do
		if Rails.env.development?
			UserPlan.routine_payments
			Service.routine_inactive_services
			FreightOrderOption.routine_update_freight_order_status

			@system_configuration = SystemConfiguration.first
			if !@system_configuration.melhor_envio_expires_date.nil? && (Date.today + 10.days) > @system_configuration.melhor_envio_expires_date
				refresh_token = @system_configuration.melhor_envio_refresh_token
				# Gerar novo access e refresh token
				service = Utils::MelhorEnvio::RefreshTokenService.new(refresh_token)
				transaction = service.call
				if transaction[0]
					new_access_token = transaction[2]["access_token"]
					new_refresh_token = transaction[2]["refresh_token"]
					new_expires_data = Date.today + 30.days
					@system_configuration.update_columns(melhor_envio_access_token: new_access_token, melhor_envio_refresh_token: new_refresh_token, melhor_envio_expires_date: new_expires_data)
				end
			end
		end
	end

end