module Utils
  module Locale
    class ChangeLocaleService < BaseService
      attr_reader :cep

      def initialize(locale, session)
        @locale = locale
        @session = session
      end

      def call
        return [false, 'pt-BR'] if invalid?
        change_locale
      end

      private

      def invalid?
        @locale.nil? || @locale.blank? ||
        @session.nil? || @session.blank? ||
        (@locale != 'pt-BR' && @locale != 'en')
      end

      def change_locale
        begin
          return [true, @locale]
        rescue Exception => e
          return [false, 'pt-BR']
        end
      end

    end
  end
end
