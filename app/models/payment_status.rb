class PaymentStatus < ApplicationRecord
	validates_presence_of :name

	CANCELADO_ID = 1
	ESTORNADO_ID = 2
	NAO_AUTORIZADO_ID = 3
	NAO_PAGO_ID = 4
	PAGO_ID = 5
	AGUARDANDO_PAGAMENTO_ID = 6

	PAYMENT_STATUS_PAY_CIELO_1 = 4
	PAYMENT_STATUS_PAY_CIELO_2 = 6

end
