require 'uri'
FactoryBot.define do
	factory :attachment do
		association :ownertable, factory: :country
		attachment_type {Faker::Number.number(digits: 1)}

		after(:create) do |object|
			object.attachment.attach(io: File.open("#{Rails.root}/spec/support/files/500x500.png"), filename: "500x500.png")
		end
	end
end
