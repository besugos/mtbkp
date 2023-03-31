FactoryBot.define do
  factory :seller_coupon do
    association :coupon_type
    association :coupon_area
    
    name {Faker::Lorem.sentence(word_count: 1)}
    quantity {Faker::Number.number(digits: 2)}
    validate_date {Faker::Date.between(from: 1.years.from_now, to: 2.years.from_now)}
    value {Faker::Commerce.price}
  end
end
