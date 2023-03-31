module Utils
  module PagSeguro
    class PagSeguroAccessService < BaseService

      def initialize
        @url = nil
        @token = nil
      end

      def call
        return nil if invalid?
        define_environment_data
        return_environment_data
      end

      private

      def invalid?
        if Rails.env.development?
          return (ENV['PAGSEGURO_DESENV_URL'].nil? || ENV['PAGSEGURO_DESENV_URL'].blank?) || (ENV['PAGSEGURO_DESENV_TOKEN'].nil? || ENV['PAGSEGURO_DESENV_TOKEN'].blank?)
        elsif Rails.env.production?
          return (ENV['PAGSEGURO_PRODUCTION_URL'].nil? || ENV['PAGSEGURO_PRODUCTION_URL'].blank?) || (ENV['PAGSEGURO_PRODUCTION_TOKEN'].nil? || ENV['PAGSEGURO_PRODUCTION_TOKEN'].blank?)
        end
      end

      def define_environment_data
        if Rails.env.development?
          @url = ENV['PAGSEGURO_DESENV_URL']
          @token = "Bearer "+ENV['PAGSEGURO_DESENV_TOKEN']
        elsif Rails.env.production?
          @url = ENV['PAGSEGURO_PRODUCTION_URL']
          @token = "Bearer "+ENV['PAGSEGURO_PRODUCTION_TOKEN']
        end
      end

      def return_environment_data
        return [@url, @token]
      end

    end
  end
end
