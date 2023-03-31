FactoryBot.define do
	factory :user do
		
		association :profile
		association :person_type
		association :sex

		seed {true}
		name {Faker::Name.name}
		email {Faker::Internet.email}
		access_user {Faker::IDNumber.valid}
		password {Faker::Internet.password}
		recovery_token {SecureRandom.urlsafe_base64}
		is_blocked {false}
		cpf {Faker::CPF.pretty}
		rg {Faker::Number.number(digits: 7)}
		birthday {Faker::Date.between(from: 30.years.ago, to: 19.years.ago)}
		phone {"(99) 99999-9999"}
		cellphone {"(99) 99999-9999"}

		cnpj {Faker::CNPJ.pretty}
		social_name {Faker::Company.name}
		fantasy_name {Faker::Company.name}

		publish_professional_profile {rand(0..1)}

		description {Faker::Lorem.sentence(word_count: 300)}
		work_experience {Faker::Lorem.sentence(word_count: 300)}

		deadline_avaliation {rand(1..5)}
		quality_avaliation {rand(1..5)}
		problems_solution_avaliation {rand(1..5)}
		seller_verified {true}
		accept_therm {true}
		publish_professional_profile {true}

		after(:create) do |object|
			if object.user?
				object.profile_image.attach(io: File.open("#{Rails.root}/spec/support/files/500x500.png"), filename: "500x500.png")
				FactoryBot.create(:data_professional, user_id: object.id, professional_document_status_id: ProfessionalDocumentStatus::VALIDADO_ID)
			end
		end

	end
end