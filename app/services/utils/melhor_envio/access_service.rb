module Utils
  module MelhorEnvio
    class AccessService < BaseService

      def initialize
        @url = nil
        @client_id = nil
        @client_secret = nil
        @token = nil
        @refresh_token = nil
        @system_configuration = SystemConfiguration.first
      end

      def call
        return nil if invalid?
        define_environment_data
        return_environment_data
      end

      private

      def invalid?
        if Rails.env.development?
          return (ENV['MELHOR_ENVIO_DESENV_URL'].nil? || ENV['MELHOR_ENVIO_DESENV_URL'].blank?) || 
          (ENV['MELHOR_ENVIO_DESENV_CLIENT_ID'].nil? || ENV['MELHOR_ENVIO_DESENV_CLIENT_ID'].blank?) ||
          (ENV['MELHOR_ENVIO_DESENV_CLIENT_SECRET'].nil? || ENV['MELHOR_ENVIO_DESENV_CLIENT_SECRET'].blank?) ||
          (@system_configuration.melhor_envio_access_token.nil? || @system_configuration.melhor_envio_access_token.blank?)
        elsif Rails.env.production?
          return (ENV['MELHOR_ENVIO_PRODUCTION_URL'].nil? || ENV['MELHOR_ENVIO_PRODUCTION_URL'].blank?) || 
          (ENV['MELHOR_ENVIO_PRODUCTION_CLIENT_ID'].nil? || ENV['MELHOR_ENVIO_PRODUCTION_CLIENT_ID'].blank?) ||
          (ENV['MELHOR_ENVIO_PRODUCTION_CLIENT_SECRET'].nil? || ENV['MELHOR_ENVIO_PRODUCTION_CLIENT_SECRET'].blank?) ||
          (@system_configuration.melhor_envio_access_token.nil? || @system_configuration.melhor_envio_access_token.blank?)
        end
      end

      def define_environment_data
        if Rails.env.development?
          @url = ENV['MELHOR_ENVIO_DESENV_URL']
          @client_id = ENV['MELHOR_ENVIO_DESENV_CLIENT_ID']
          @client_secret = ENV['MELHOR_ENVIO_DESENV_CLIENT_SECRET']
          @token = "Bearer "+@system_configuration.melhor_envio_access_token
        elsif Rails.env.production?
          @url = ENV['MELHOR_ENVIO_PRODUCTION_URL']
          @client_id = ENV['MELHOR_ENVIO_PRODUCTION_CLIENT_ID']
          @client_secret = ENV['MELHOR_ENVIO_PRODUCTION_CLIENT_SECRET']
          @token = "Bearer "+@system_configuration.melhor_envio_access_token
        end
      end

      def return_environment_data
        return [@url, @client_id, @client_secret, @token]
      end

    end
  end
end
