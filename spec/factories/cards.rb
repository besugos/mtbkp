FactoryBot.define do
	factory :card do
		association :card_banner
		name {Faker::Lorem.paragraph}
		nickname {Faker::Lorem.paragraph}
		number {"5125 3766 3439 7387"}
		validate_date_month {Faker::Date.between(from: Date.today, to: 10.days.from_now).strftime('%m')}
		validate_date_year {Faker::Date.between(from: Date.today, to: 10.years.from_now).strftime('%Y')}
		principal {Faker::Boolean.boolean}
		ccv_code {Faker::Number.number(digits: 3)}
	end
end
