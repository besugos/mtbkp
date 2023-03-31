class PaymentTransactionsController < ApplicationController
	skip_before_action :authenticate_user
	skip_before_action :verify_authenticity_token

	def notify_pix_payment
		begin
			order_id = params["id"]
			payment_transaction = PaymentTransaction.where(pix_order_id: order_id)
			.where.not(payment_status_id: PaymentStatus::PAGO_ID)
			.first
			if payment_transaction
				charges = params["charges"]
				if charges.length > 0
					current_charge_status = charges[0]["status"]
					if current_charge_status == "PAID"
						PaymentTransaction.set_paid_payment_transaction(payment_transaction)
					end
				end
			end
			respond_to do |format|
				format.json {render :json => true, :status => 200}
			end
		rescue Exception => e
			Rails.logger.error e.message
			respond_to do |format|
				format.json {render :json => false, :status => 200}
			end
		end
	end

	def notify_change_payment
		begin
			order_id = params["id"]
			payment_transaction = PaymentTransaction.where(payment_code: order_id)
			.where.not(payment_status_id: PaymentStatus::PAGO_ID)
			.first
			if payment_transaction
				payment_response = params["payment_response"]
				if !payment_response.nil?
					current_charge_status = payment_response["code"]
					if current_charge_status.to_s == '20000' && current_charge_status["status"] == "PAID"
						PaymentTransaction.set_paid_payment_transaction(payment_transaction)
					end
				end
			end
			respond_to do |format|
				format.json {render :json => true, :status => 200}
			end
		rescue Exception => e
			Rails.logger.error "-- notify_change_payment --"
			Rails.logger.error e.message
			respond_to do |format|
				format.json {render :json => false, :status => 200}
			end
		end
	end

end
