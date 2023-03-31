FactoryBot.define do
	factory :order do
		price {Faker::Commerce.price}
		association :order_status
		association :user
	end
end
