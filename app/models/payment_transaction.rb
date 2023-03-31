class PaymentTransaction < ApplicationRecord
	belongs_to :payment_status

	belongs_to :ownertable, :polymorphic => true

	GATEWAY_PAGSEGURO = 'pagseguro'
	GATEWAY_CIELO = 'cielo'

	SOFT_DESCRIPTOR = 'sistemamercadotopografico'

	def self.set_paid_payment_transaction(payment_transaction)
		begin
			payment_transaction.update_columns(payment_status_id: PaymentStatus::PAGO_ID)
			payment_transaction.ownertable.update_columns(order_status_id: OrderStatus::PAGAMENTO_REALIZADO_ID)
			current_order = payment_transaction.ownertable
			if current_order
				UserPlan.generate_or_update_user_plan(current_order.user, current_order)
			end
			Order.setting_limit_cancel_order(payment_transaction.ownertable)
			first_order_cart = current_order.order_carts.first
			if !first_order_cart.nil? && first_order_cart.ownertable_type == "Product"
				Order.generate_order_melhor_envio(current_order)
			end
		rescue Exception => e
			Rails.logger.error e.message
		end
	end
end
