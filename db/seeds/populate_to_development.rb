user = Profile.find_or_create_by(name: Profile::USER)

current_user = FactoryBot.create(:user, person_type_id: 1, 
	sex_id: rand(1..2), 
	name: 'Usuário Teste', 
	profile: user, 
	email: 'usuario@usuario.com',
	password: ENV['ADMIN_1_SENHA'],
	new_user: true,
	cpf: "497.092.970-07",
	phone: "(99) 99999-9999",
	cellphone: "(99) 99999-9999",
	seed: true)

current_user_2 = FactoryBot.create(:user,
	person_type_id: 1, 
	sex_id: rand(1..2), 
	name: 'Usuário Teste Dois', 
	profile: user, 
	email: 'usuario2@usuario2.com',
	password: ENV['ADMIN_1_SENHA'],
	new_user: true,
	cpf: "876.809.880-48",
	phone: "(99) 99999-9999",
	cellphone: "(99) 99999-9999",
	seed: true)

for i in 0..2 do
	FactoryBot.create(:banner, banner_area_id: 1, position: (i+1), seed: true)
	FactoryBot.create(:banner, banner_area_id: 2, position: (i+1), seed: true)
	FactoryBot.create(:banner, banner_area_id: 3, position: (i+1), seed: true)
	FactoryBot.create(:banner, banner_area_id: 4, position: (i+1), seed: true)
	FactoryBot.create(:address, ownertable: current_user, country_id: 33, state_id: rand(1..25), city_id: rand(1..3000), address_type_id: nil, address_area_id: AddressArea::ENDERECO_SAIDA_ID)
	FactoryBot.create(:address, ownertable: current_user_2, country_id: 33, state_id: rand(1..25), city_id: rand(1..3000), address_type_id: nil, address_area_id: AddressArea::ENDERECO_SAIDA_ID)
end

product_category = FactoryBot.create(:category, category_type_id: CategoryType::PRODUTOS_ID)
sub_category = SubCategory.where(category_id: product_category.id).first

for i in 0..8 do
	FactoryBot.create(:seller_coupon, coupon_type_id: rand(1..2), coupon_area_id: rand(1..2))
	FactoryBot.create(:product, category_id: product_category.id, sub_category_id: sub_category.id, user_id: rand(3..4), product_condition_id: rand(1..2))
	FactoryBot.create(:service, category_id: rand(1..12), sub_category_id: nil, user_id: rand(3..4), radius_service_id: rand(1..4))
end