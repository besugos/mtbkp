FactoryBot.define do
	factory :product do
		association :category
		association :sub_category
		association :user
		association :product_condition

		title {Faker::Commerce.product_name}
		price {Faker::Commerce.price}
		avaliation_value {rand(1..5)}
		description {Faker::Lorem.paragraph}

		quantity_stock {Faker::Number.number(digits: 2)}
		promotional_price {Faker::Commerce.price}
		width {Faker::Number.number(digits: 2)}
		height {Faker::Number.number(digits: 2)}
		depth {Faker::Number.number(digits: 2)}
		weight {Faker::Number.number(digits: 2)}

		after(:create) do |object|
			object.principal_image.attach(io: File.open("#{Rails.root}/spec/support/files/500x500.png"), filename: "500x500.png")
			FactoryBot.create(:address, 
				ownertable: object, 
				state_id: rand(1..27), 
				city_id: rand(1..5000), 
				country_id: rand(1..200), 
				address_type_id: rand(1..40), 
				address_area_id: AddressArea::GENERAL_ID)
			for i in 0..2
				FactoryBot.create(:attachment, ownertable: object)
			end
		end

	end
end
