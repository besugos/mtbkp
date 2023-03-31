FactoryBot.define do
	factory :system_configuration do

		notification_mail {Faker::Internet.email}
		contact_mail {Faker::Internet.email}
		
		use_policy {Faker::Lorem.sentence(word_count: 300)}
		privacy_policy {Faker::Lorem.sentence(word_count: 300)}
		warranty_policy {Faker::Lorem.sentence(word_count: 300)}
		exchange_policy {Faker::Lorem.sentence(word_count: 300)}

		phone {Faker::Number.number(digits: 11)}
		cellphone {Faker::Number.number(digits: 11)}
		cnpj {Faker::CNPJ.pretty}

		data_security_policy {Faker::Lorem.sentence(word_count: 300)}
		quality {Faker::Lorem.sentence(word_count: 300)}
		mission {Faker::Lorem.sentence(word_count: 300)}
		view {Faker::Lorem.sentence(word_count: 300)}
		values {Faker::Lorem.sentence(word_count: 300)}
		
		about {Faker::Lorem.sentence(word_count: 300)}
		
		about_video_link {Faker::Internet.url(host: 'youtube.com')}

		site_link {Faker::Internet.url}
		facebook_link {Faker::Internet.url(host: 'facebook.com')}
		instagram_link {Faker::Internet.url(host: 'instagram.com')}
		twitter_link {Faker::Internet.url(host: 'twitter.com')}
		youtube_link {Faker::Internet.url(host: 'youtube.com')}
		linkedin_link {Faker::Internet.url(host: 'linkedin.com')}

		page_title {Faker::Lorem.paragraph}
		page_description {Faker::Lorem.paragraph}

		geral_conditions {Faker::Lorem.sentence(word_count: 300)}
		contract_data {Faker::Lorem.sentence(word_count: 300)}
		
		attendance_data {Faker::Lorem.sentence(word_count: 300)}

		professional_contact_phone {"(31) 99999-9999"}
		client_contact_phone {"(31) 99999-9999"}
		professional_contact_mail {Faker::Internet.email}
		client_contact_mail {Faker::Internet.email}

		after(:create) do |object|
			object.client_logo.attach(io: File.open("#{Rails.root}/app/assets/images/logos/logo.png"), filename: "logo.png")
			object.favicon.attach(io: File.open("#{Rails.root}/app/assets/images/favicon/favicon.png"), filename: "favicon.png")
			object.about_image.attach(io: File.open("#{Rails.root}/app/assets/images/favicon/favicon.png"), filename: "favicon.png")
			FactoryBot.create(:address, 
				ownertable: object, 
				state_id: rand(1..27), 
				city_id: rand(1..5000), 
				country_id: rand(1..200), 
				address_type_id: rand(1..40), 
				address_area_id: AddressArea::GENERAL_ID)
		end

	end
end
