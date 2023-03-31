FactoryBot.define do
  factory :data_professional do
    association :user
    association :professional_document_status
    email {Faker::Internet.email}
    phone {"(99) 99999-9999"}
    site {Faker::Internet.url}
    profession {Faker::Lorem.paragraph}
    register_type {Faker::Lorem.paragraph}
    register_number {Faker::Number.number(digits: 11)}
    repprovation_reason {Faker::Lorem.paragraph}
  end
end
