FactoryBot.define do
  factory :payment_type do
    name {Faker::Lorem.paragraph}
  end
end
