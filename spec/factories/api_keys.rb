FactoryBot.define do
	factory :api_key do
		access_token {Faker::Number.number(digits: 12)}
		expires_at {Faker::Date.between(from: Date.today, to: 10.days.from_now)}
		user_id {1}
		active {Faker::Boolean.boolean}
	end
end
