FactoryBot.define do
	factory :email do
		association :ownertable, factory: :country
		email {Faker::Internet.email}
		association :email_type
	end
end
