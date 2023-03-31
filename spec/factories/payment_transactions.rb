FactoryBot.define do
	factory :payment_transaction do
		association :payment_status
		association :ownertable 
		payment_message {Faker::Lorem.paragraph}
		payment_code {Faker::Number.number(9)}
		value {Faker::Number.decimal(l_digits: 2, r_digits: 2)}
	end
end
