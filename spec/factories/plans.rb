FactoryBot.define do
  factory :plan do
    association :category
    association :sub_category
    association :plan_periodicity

    name {Faker::Commerce.product_name}
    price {Faker::Commerce.price}
    old_price {Faker::Commerce.price}
    active { true }
    description {Faker::Lorem.paragraph}
    observations {Faker::Lorem.paragraph}

    after(:create) do |object|
      FactoryBot.create_list(:plan_service, 3, plan: object)
      object.image.attach(io: File.open("#{Rails.root}/spec/support/files/500x500.png"), filename: "500x500.png")
      object.banner_image.attach(io: File.open("#{Rails.root}/spec/support/files/1200x300.png"), filename: "1200x300.png")
    end
    
  end
end
