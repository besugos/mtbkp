FactoryBot.define do
  factory :freight_order_option do
    freight_order { nil }
    name { "MyString" }
    price { "9.99" }
    delivery_time { 1 }
    freight_company { nil }
    selected { false }
  end
end
