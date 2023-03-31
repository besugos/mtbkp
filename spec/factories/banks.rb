FactoryBot.define do
	factory :bank do
		name {Faker::Lorem.paragraph}
		number {Faker::Number.number(digits: 3)}
	end
end
