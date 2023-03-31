class CardSerializer < ActiveModel::Serializer

	attributes :id, :card_banner_id, :card_banner

	attribute :formatted_name do
		if !object.nil?
			object.get_formatted_name
		end
	end

	attribute :formatted_validate_date do
		if !object.nil?
			object.get_formatted_validate_date
		end
	end

end  