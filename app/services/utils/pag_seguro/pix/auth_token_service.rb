module Utils
  module PagSeguro
    module Pix
      class AuthTokenService < BaseService

        def initialize
          @url = nil
          @cert_name = nil
          @key_name = nil
          @client_id = nil
          @client_secret = nil
          @token = nil
          @url_general = nil
        end

        def call
          return nil if invalid?
          define_environment_data
          return_environment_data
        end

        private

        def invalid?
          if Rails.env.development?
            return (ENV['PAGSEGURO_PIX_DESENV_URL'].nil? || ENV['PAGSEGURO_PIX_DESENV_URL'].blank?) || 
            (ENV['PAGSEGURO_PIX_CERT_DESENV'].nil? || ENV['PAGSEGURO_PIX_CERT_DESENV'].blank?) || 
            (ENV['PAGSEGURO_PIX_KEY_DESENV'].nil? || ENV['PAGSEGURO_PIX_KEY_DESENV'].blank?) ||
            (ENV['PAGSEGURO_DESENV_TOKEN'].nil? || ENV['PAGSEGURO_DESENV_TOKEN'].blank?) ||
            (ENV['PAGSEGURO_DESENV_URL'].nil? || ENV['PAGSEGURO_DESENV_URL'].blank?) ||
            (ENV['PAGSEGURO_DESENV_CLIENT_ID'].nil? || ENV['PAGSEGURO_DESENV_CLIENT_ID'].blank?) ||
            (ENV['PAGSEGURO_DESENV_CLIENT_SECRET'].nil? || ENV['PAGSEGURO_DESENV_CLIENT_SECRET'].blank?) 
          elsif Rails.env.production?
            return (ENV['PAGSEGURO_PIX_PRODUCTION_URL'].nil? || ENV['PAGSEGURO_PIX_PRODUCTION_URL'].blank?) || 
            (ENV['PAGSEGURO_PIX_CERT_PRODUCTION'].nil? || ENV['PAGSEGURO_PIX_CERT_PRODUCTION'].blank?) || 
            (ENV['PAGSEGURO_PIX_KEY_PRODUCTION'].nil? || ENV['PAGSEGURO_PIX_KEY_PRODUCTION'].blank?) ||
            (ENV['PAGSEGURO_PRODUCTION_TOKEN'].nil? || ENV['PAGSEGURO_PRODUCTION_TOKEN'].blank?) ||
            (ENV['PAGSEGURO_PRODUCTION_URL'].nil? || ENV['PAGSEGURO_PRODUCTION_URL'].blank?) ||
            (ENV['PAGSEGURO_PRODUCTION_CLIENT_ID'].nil? || ENV['PAGSEGURO_PRODUCTION_CLIENT_ID'].blank?) ||
            (ENV['PAGSEGURO_PRODUCTION_CLIENT_SECRET'].nil? || ENV['PAGSEGURO_PRODUCTION_CLIENT_SECRET'].blank?) 
          end
        end

        def define_environment_data
          if Rails.env.development?
            @url = ENV['PAGSEGURO_PIX_DESENV_URL']
            @cert_name = ENV['PAGSEGURO_PIX_CERT_DESENV']
            @key_name = ENV['PAGSEGURO_PIX_KEY_DESENV']
            @token = ENV['PAGSEGURO_DESENV_TOKEN']
            @url_general = ENV['PAGSEGURO_DESENV_URL']
            @client_id = ENV['PAGSEGURO_DESENV_CLIENT_ID']
            @client_secret = ENV['PAGSEGURO_DESENV_CLIENT_SECRET']
          elsif Rails.env.production?
            @url = ENV['PAGSEGURO_PIX_PRODUCTION_URL']
            @cert_name = ENV['PAGSEGURO_PIX_CERT_PRODUCTION']
            @key_name = ENV['PAGSEGURO_PIX_KEY_PRODUCTION']
            @token = ENV['PAGSEGURO_PRODUCTION_TOKEN']
            @url_general = ENV['PAGSEGURO_PRODUCTION_URL']
            @client_id = ENV['PAGSEGURO_PRODUCTION_CLIENT_ID']
            @client_secret = ENV['PAGSEGURO_PRODUCTION_CLIENT_SECRET']
          end
        end

        def return_environment_data
          return [@url, @cert_name, @key_name, @client_id, @client_secret, @token, @url_general]
        end

      end
    end
  end
end
