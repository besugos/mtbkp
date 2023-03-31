class FreightOrderOption < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  belongs_to :freight_order
  belongs_to :freight_company
  belongs_to :freight_order_status
  
  def get_text_name
    self.name.to_s
  end

  def self.format_volume_to_melhor_envio(freight_order_option)
    result = []
    complete_data = JSON.parse(freight_order_option.melhor_envio_complete_data)
    complete_data["packages"].each do |package|
      volume = {
        height: package["dimensions"]["height"].to_f,
        width: package["dimensions"]["width"].to_f,
        length: package["dimensions"]["length"].to_f,
        weight: package["weight"].to_f
      }
      result.push(volume)
    end
    return result
  end

  def self.getting_tracking_code(freight_order_option)
    result = ""
    if !freight_order_option.melhor_envio_checkout_data.nil? && !freight_order_option.melhor_envio_checkout_data.blank?
      melhor_envio_checkout_data = JSON.parse(freight_order_option.melhor_envio_checkout_data)
      if !melhor_envio_checkout_data.nil? && !melhor_envio_checkout_data["tracking"].nil?
        result = melhor_envio_checkout_data["tracking"]
      end
    end
    return result
  end

  def self.getting_posted_at(freight_order_option)
    result = ""
    if !freight_order_option.melhor_envio_checkout_data.nil? && !freight_order_option.melhor_envio_checkout_data.blank?
      melhor_envio_checkout_data = JSON.parse(freight_order_option.melhor_envio_checkout_data)
      if !melhor_envio_checkout_data.nil? && !melhor_envio_checkout_data["posted_at"].nil?
        result = melhor_envio_checkout_data["posted_at"]
      end
    end
    return result
  end

  def self.getting_delivered_at(freight_order_option)
    result = ""
    if !freight_order_option.melhor_envio_checkout_data.nil? && !freight_order_option.melhor_envio_checkout_data.blank?
      melhor_envio_checkout_data = JSON.parse(freight_order_option.melhor_envio_checkout_data)
      if !melhor_envio_checkout_data.nil? && !melhor_envio_checkout_data["delivered_at"].nil?
        result = melhor_envio_checkout_data["delivered_at"]
      end
    end
    return result
  end

  def self.get_url_print(freight_order_option)
    result = ""
    melhor_envio_checkout_data = JSON.parse(freight_order_option.melhor_envio_checkout_data)
    if !melhor_envio_checkout_data.nil? && !melhor_envio_checkout_data["id"].nil?
      order_id = melhor_envio_checkout_data["id"]
      service = Utils::MelhorEnvio::PrintService.new(order_id)
      transaction = service.call
      if transaction[0]
        result_transaction = transaction[2]
        if !result_transaction["url"].nil?
          result = result_transaction["url"]
        end
      end
    end
    return result
  end

  def self.routine_update_freight_order_status
    freight_order_options = FreightOrderOption.where(freight_order_status_id: [FreightOrderStatus::AGUARDANDO_ENVIO_ID, FreightOrderStatus::EM_ROTA_DE_ENVIO_ID])
    freight_order_options.each do |freight_order_option|
      Order.updating_status_selected_freight_order_option(freight_order_option)
      if !freight_order_option.reload.melhor_envio_checkout_data.nil? && !freight_order_option.reload.melhor_envio_checkout_data.blank?
        freight_order_option.reload
        melhor_envio_checkout_data = JSON.parse(freight_order_option.melhor_envio_checkout_data)
        if !melhor_envio_checkout_data.nil?
          if !melhor_envio_checkout_data["canceled_at"].nil?
            freight_order_status_id = FreightOrderStatus::ENVIO_PEDIDO_CANCELADO_ID
          elsif !melhor_envio_checkout_data["delivered_at"].nil?
            freight_order_status_id = FreightOrderStatus::ENTREGUE_ID
          elsif !melhor_envio_checkout_data["posted_at"].nil?
            freight_order_status_id = FreightOrderStatus::EM_ROTA_DE_ENVIO_ID
          end
          freight_order_option.update_columns(freight_order_status_id: freight_order_status_id)
        end
      end
    end
  end

  private

  def default_values
    self.name ||= ""
    self.tracking_code ||= ""
    self.selected ||= false if self.selected.nil?
    self.freight_order_status_id ||= FreightOrderStatus::AGUARDANDO_ENVIO_ID
  end

end
