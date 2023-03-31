module Utils
  module Cep
    class CepService < BaseService
      attr_reader :cep

      def initialize(cep)
        @cep = cep.gsub(/[.,-]/, "")
      end

      def call
        return false if invalid?
        define_timeout
        get_cep
      end

      private

      def invalid?
        !(cep.length == 8 && !!(cep =~ /\A[-+]?[0-9]+\z/))
      end

      def define_timeout
        Correios::CEP.configure do |config|
          config.request_timeout = 120
        end
      end

      def get_cep
        begin
          Correios::CEP::AddressFinder.get(cep)
        rescue Exception => e
          return nil
        end
      end

    end
  end
end
