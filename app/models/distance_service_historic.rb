class DistanceServiceHistoric < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  scope :by_lat_origin, lambda { |value| where("lat_origin = ?", value) if !value.nil? && !value.blank? }
  scope :by_lng_origin, lambda { |value| where("lng_origin = ?", value) if !value.nil? && !value.blank? }
  scope :by_lat_destination, lambda { |value| where("lat_destination = ?", value) if !value.nil? && !value.blank? }
  scope :by_lng_destination, lambda { |value| where("lng_destination = ?", value) if !value.nil? && !value.blank? }
  
  def get_text_name
    self.id.to_s
  end

  def self.create_new_distance_service_historic(lat_origin, lng_origin, lat_destination, lng_destination, google_result)

    if (!lat_origin.nil? && !lat_origin.blank?) && (!lng_origin.nil? && !lng_origin.blank?) && (!lat_destination.nil? && !lat_destination.blank?) && (!lng_destination.nil? && !lng_destination.blank?) && (!google_result.nil? && (!google_result[:duration_value].nil? && !google_result[:duration_value].blank?))
      old_register = DistanceServiceHistoric.by_lat_origin(lat_origin.to_s)
      .by_lng_origin(lng_origin.to_s)
      .by_lat_destination(lat_destination.to_s)
      .by_lng_destination(lng_destination.to_s).first

      if old_register
        old_register.update_columns(
          distance_value: google_result[:distance_value]
          )
      else
        DistanceServiceHistoric.create(
          lat_origin: lat_origin,
          lng_origin: lng_origin,
          lat_destination: lat_destination,
          lng_destination: lng_destination,
          destination_address: google_result[:destination_address],
          origin_address: google_result[:origin_address],
          distance_text: google_result[:distance_text],
          duration_text: google_result[:duration_text],
          distance_value: google_result[:distance_value],
          duration_value: google_result[:duration_value]
          )
      end
    end

  end

  private

  def default_values
  end

end
