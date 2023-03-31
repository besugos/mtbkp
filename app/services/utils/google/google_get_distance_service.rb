module Utils
  module Google
    class GoogleGetDistanceService < BaseService

      def initialize(lat_origin, lng_origin, lat_destination, lng_destination)
        @lat_origin = lat_origin
        @lng_origin = lng_origin
        @lat_destination = lat_destination
        @lng_destination = lng_destination
      end

      def call
        return [false, 'pt-BR'] if invalid?
        get_distance
      end

      private

      def invalid?
        @lat_origin.nil? || @lat_origin.blank? ||
        @lng_origin.nil? || @lng_origin.blank? ||
        @lat_destination.nil? || @lat_destination.blank? ||
        @lng_destination.nil? || @lng_destination.blank?
      end

      def get_distance
        begin
          gmaps = GoogleMapsService::Client.new

          origin = [[@lat_origin, @lng_origin]]
          destination = [[@lat_destination, @lng_destination]]
          routes = gmaps.distance_matrix(
            origin,
            destination,
            mode: 'driving',
            language: 'pt-BR')
          status = routes[:rows][0][:elements][0][:status]

          if status != Address::GOOGLE_ZERO_RESULTS
            destination_address = routes[:destination_addresses][0]
            origin_address = routes[:origin_addresses][0]
            distance_text = routes[:rows][0][:elements][0][:distance][:text]
            duration_text = routes[:rows][0][:elements][0][:duration][:text]
            distance_value = routes[:rows][0][:elements][0][:distance][:value]
            duration_value = routes[:rows][0][:elements][0][:duration][:value]
            results = {
              destination_address: destination_address,
              origin_address: origin_address,
              distance_text: distance_text,
              duration_text: duration_text,
              distance_value: distance_value,
              duration_value: duration_value
            }
          else
            results = {}
          end
          return [true, results]
        rescue Exception => e
          Rails.logger.error e.message
          return [false, e.message]
        end
      end

    end
  end
end
