FactoryBot.define do
  factory :user_plan do
    user { nil }
    plan { nil }
    initial_date { "2022-09-23 00:12:49" }
    final_date { "2022-09-23 00:12:49" }
    price { "9.99" }
    next_payment { "2022-09-23" }
    count_paid { 1 }
    plan_price { "9.99" }
    use_discount_coupon { false }
  end
end
