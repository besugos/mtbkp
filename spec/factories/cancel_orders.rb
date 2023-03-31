FactoryBot.define do
  factory :cancel_order do
    order { nil }
    cancel_order_reason { nil }
    reason_text { "MyText" }
  end
end
