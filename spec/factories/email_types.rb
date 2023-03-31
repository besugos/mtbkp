FactoryBot.define do
	factory :email_type do
		name {Faker::Lorem.paragraph}
	end
end
