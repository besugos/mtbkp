class ProductSerializer < ActiveModel::Serializer
	
	attributes :id, :title, :price, :description

	attribute :price_formatted do
		CustomHelper.to_currency(object.price)
	end
	
end
