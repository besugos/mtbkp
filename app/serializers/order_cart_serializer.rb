class OrderCartSerializer < ActiveModel::Serializer

	attributes :id,
	:created_at,
	:updated_at,
	:order_id,
	:ownertable,
	:quantity,
	:unity_price,
	:total_value,
	:freight_value,
	:freight_value_total

	attribute :created_at_formatted do
		CustomHelper.get_text_date(object.created_at, 'datetime', :full)
	end

	attribute :updated_at_formatted do
		CustomHelper.get_text_date(object.updated_at, 'datetime', :full)
	end

	attribute :unity_price_formatted do
		CustomHelper.to_currency(object.unity_price)
	end

	attribute :total_value_formatted do
		CustomHelper.to_currency(object.total_value)
	end

	attribute :freight_value_formatted do
		CustomHelper.to_currency(object.freight_value)
	end

	attribute :freight_value_total_formatted do
		CustomHelper.to_currency(object.freight_value_total)
	end

end  