FactoryBot.define do
	factory :order_status do
		name {Faker::Lorem.paragraph}
	end
end
