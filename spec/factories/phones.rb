FactoryBot.define do
	factory :phone do
		association :ownertable, factory: :country
		phone_code {Faker::Number.number(digits: 2)}
		phone {Faker::Number.number(digits: 9)}
		association :phone_type
		is_whatsapp {Faker::Boolean.boolean}
		responsible {Faker::Name.name}
	end
end
