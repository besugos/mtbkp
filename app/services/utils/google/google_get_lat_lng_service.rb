module Utils
  module Google
    class GoogleGetLatLngService < BaseService

      def initialize(address)
        @address = address
      end

      def call
        return [false, 'pt-BR'] if invalid?
        get_lat_lng
      end

      private

      def invalid?
        @address.nil? || @address.blank?
      end

      def get_lat_lng
        begin
          gmaps = GoogleMapsService::Client.new
          # Geocoding an address
          results = gmaps.geocode(@address)
          return [true, results]
        rescue Exception => e
          Rails.logger.error e.message
          return [false, e.message]
        end
      end

    end
  end
end
