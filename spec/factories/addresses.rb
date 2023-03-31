FactoryBot.define do
    factory :address do
        association :ownertable, factory: :country
        association :state
        association :city
        association :address_type
        association :address_area
        association :country

        name {Faker::Lorem.sentence(word_count: 2)}
        zipcode {Faker::Address.zip_code}
        address {Faker::Address.street_address}
        district {Faker::Address.street_name}
        number {Faker::Number.number(digits: 3)}
        complement {Faker::Address.secondary_address}
        reference {Faker::Lorem.paragraph}
    end
end
