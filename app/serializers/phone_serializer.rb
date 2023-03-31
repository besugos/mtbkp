class PhoneSerializer < ActiveModel::Serializer

	attributes :id,
	:phone_code,
	:phone,
	:responsible,
	:phone_type_id,
	:phone_type,
	:is_whatsapp

	attribute :phone_formatted do
		object.get_phone_formatted
	end

end  