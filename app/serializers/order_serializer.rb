class OrderSerializer < ActiveModel::Serializer

	attributes :id,
	:created_at,
	:updated_at,
	:order_status_id,
	:order_status,
	:user_id,
	:payment_type_id,
	:payment_type,
	:installments,
	:price,
	:total_value,
	:total_freight_value

	attribute :created_at_formatted do
		CustomHelper.get_text_date(object.created_at, 'datetime', :full)
	end

	attribute :updated_at_formatted do
		CustomHelper.get_text_date(object.updated_at, 'datetime', :full)
	end

	attribute :price_formatted do
		CustomHelper.to_currency(object.price)
	end

	attribute :total_value_formatted do
		CustomHelper.to_currency(object.total_value)
	end

	attribute :total_freight_value_formatted do
		CustomHelper.to_currency(object.total_freight_value)
	end

end  