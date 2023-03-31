FactoryBot.define do
  factory :banner do
    association :banner_area

    link { Faker::Internet.url }
    title { Faker::Lorem.paragraph }
    position {Faker::Number.number(digits: 1)}
    active {true}
    disponible_date {Faker::Date.between(from: 1.years.from_now, to: 2.years.from_now)}

    after(:create) do |object|
      object.image.attach(io: File.open("#{Rails.root}/spec/support/files/1200x300.png"), filename: "1200x300.png")
      object.image_mobile.attach(io: File.open("#{Rails.root}/spec/support/files/1200x300.png"), filename: "1200x300.png")
    end

  end
end