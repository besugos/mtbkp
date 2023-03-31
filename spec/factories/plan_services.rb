FactoryBot.define do
  factory :plan_service do
    association :plan
    title { Faker::Lorem.paragraph }
    show { true }
  end
end
