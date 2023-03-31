class CancelOrder < ApplicationRecord
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  belongs_to :order
  belongs_to :freight_order
  belongs_to :cancel_order_reason
  
  def get_text_name
    self.id.to_s
  end

  def self.cancel_order(cancel_order, current_user)
    message_content = "Desejo cancelar a compra. Motivo: "+cancel_order.cancel_order_reason.name+". Descrição: "+cancel_order.reason_text
    # cancel_order.order.update_columns(order_status_id: OrderStatus::CANCELADA_ID)
    message = Message.new(
      content: message_content, 
      sender_id: cancel_order.order.user_id, 
      receiver_id: cancel_order.freight_order.seller_id,
      order_id: cancel_order.order_id
      )
    if message.save
      array_ids = [cancel_order.order.user_id, cancel_order.freight_order.seller_id].sort
      ActionCable.server.broadcast "room_channel##{array_ids.first}##{array_ids.last}", message: message.reload
      User.sending_notification_to_user(cancel_order.freight_order.seller_id)
    end
  end

  private

  def default_values
    self.reason_text ||= ""
  end

end
