FactoryBot.define do
	factory :order_cart do
		association :order
		association :product
		quantity {Faker::Number.number(digits: 1)}
		total_value {Faker::Number.decimal(l_digits: 2, r_digits: 2)}
	end
end
