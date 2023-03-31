class EmailSerializer < ActiveModel::Serializer

	attributes :id,
	:email,
	:email_type_id,
	:email_type

end  