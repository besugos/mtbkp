class BankSerializer < ActiveModel::Serializer

	attributes :id, :number, :name

	attribute :formatted_name do
		object.get_formatted_name
	end

end