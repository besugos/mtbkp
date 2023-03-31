FactoryBot.define do
	factory :data_bank do
		association :ownertable, factory: :country
		association :bank
		association :data_bank_type

		bank_number {Faker::Number.number(digits: 3)}
		agency {Faker::Number.number(digits: 4)}
		account {Faker::Number.number(digits: 5)}
		operation {Faker::Number.number(digits: 2)}
		assignor {Faker::Name.name}
		cpf_cnpj {Faker::CPF.pretty}
		pix {Faker::CPF.pretty}
	end
end
