datetime_now = DateTime.now

array_CardBanner = [
	{name: "Visa", created_at: datetime_now, updated_at: datetime_now},
	{name: "Master", created_at: datetime_now, updated_at: datetime_now},
	{name: "Amex", created_at: datetime_now, updated_at: datetime_now},
	{name: "Elo", created_at: datetime_now, updated_at: datetime_now},
	{name: "Aura", created_at: datetime_now, updated_at: datetime_now},
	{name: "Diners", created_at: datetime_now, updated_at: datetime_now},
	{name: "Discover", created_at: datetime_now, updated_at: datetime_now},
	{name: "JCB", created_at: datetime_now, updated_at: datetime_now},
]
CardBanner.insert_all(array_CardBanner)

array_PersonType = [
	{id: 1, name: "Física", created_at: datetime_now, updated_at: datetime_now},
	{id: 2, name: "Jurídica", created_at: datetime_now, updated_at: datetime_now},
]
PersonType.insert_all(array_PersonType)

array_PhoneType = [
	{id: 1, name: "Celular", created_at: datetime_now, updated_at: datetime_now},
	{id: 2, name: "Fixo", created_at: datetime_now, updated_at: datetime_now},
	{id: 3, name: "Outro", created_at: datetime_now, updated_at: datetime_now},
]
PhoneType.insert_all(array_PhoneType)

array_EmailType = [
	{id: 1, name: "Pessoal", created_at: datetime_now, updated_at: datetime_now},
	{id: 2, name: "Trabalho", created_at: datetime_now, updated_at: datetime_now},
	{id: 3, name: "Outro", created_at: datetime_now, updated_at: datetime_now},
]
EmailType.insert_all(array_EmailType)

array_PaymentStatus = [
	{name: "Cancelado", created_at: datetime_now, updated_at: datetime_now},
	{name: "Estornado", created_at: datetime_now, updated_at: datetime_now},
	{name: "Não autorizado", created_at: datetime_now, updated_at: datetime_now},
	{name: "Não pago", created_at: datetime_now, updated_at: datetime_now},
	{name: "Pago", created_at: datetime_now, updated_at: datetime_now},
	{name: "Aguardando pagamento", created_at: datetime_now, updated_at: datetime_now},
]
PaymentStatus.insert_all(array_PaymentStatus)

array_OrderStatus = [
	{name: "Em aberto", created_at: datetime_now, updated_at: datetime_now},
	{name: "Pagamento realizado", created_at: datetime_now, updated_at: datetime_now},
	{name: "Cancelada", created_at: datetime_now, updated_at: datetime_now},
	{name: "Aguardando pagamento", created_at: datetime_now, updated_at: datetime_now},
]
OrderStatus.insert_all(array_OrderStatus)

array_CivilState = [
	{name: "Solteiro (a)", created_at: datetime_now, updated_at: datetime_now},
	{name: "Casado (a)", created_at: datetime_now, updated_at: datetime_now},
	{name: "Divorciado (a)", created_at: datetime_now, updated_at: datetime_now},
	{name: "Separado (a) judicialmente", created_at: datetime_now, updated_at: datetime_now},
	{name: "Viúvo (a)", created_at: datetime_now, updated_at: datetime_now},
	{name: "União Estável", created_at: datetime_now, updated_at: datetime_now},
]
CivilState.insert_all(array_CivilState)

array_AddressType = [
	{name: "Aeroporto", created_at: datetime_now, updated_at: datetime_now},
	{name: "Alameda", created_at: datetime_now, updated_at: datetime_now},
	{name: "Área", created_at: datetime_now, updated_at: datetime_now},
	{name: "Avenida", created_at: datetime_now, updated_at: datetime_now},
	{name: "Campo", created_at: datetime_now, updated_at: datetime_now},
	{name: "Chácara", created_at: datetime_now, updated_at: datetime_now},
	{name: "Colônia", created_at: datetime_now, updated_at: datetime_now},
	{name: "Condomínio", created_at: datetime_now, updated_at: datetime_now},
	{name: "Conjunto", created_at: datetime_now, updated_at: datetime_now},
	{name: "Distrito", created_at: datetime_now, updated_at: datetime_now},
	{name: "Esplanada", created_at: datetime_now, updated_at: datetime_now},
	{name: "Estação", created_at: datetime_now, updated_at: datetime_now},
	{name: "Estrada", created_at: datetime_now, updated_at: datetime_now},
	{name: "Favela", created_at: datetime_now, updated_at: datetime_now},
	{name: "Fazenda", created_at: datetime_now, updated_at: datetime_now},
	{name: "Feira", created_at: datetime_now, updated_at: datetime_now},
	{name: "Jardim", created_at: datetime_now, updated_at: datetime_now},
	{name: "Ladeira", created_at: datetime_now, updated_at: datetime_now},
	{name: "Lago", created_at: datetime_now, updated_at: datetime_now},
	{name: "Lagoa", created_at: datetime_now, updated_at: datetime_now},
	{name: "Largo", created_at: datetime_now, updated_at: datetime_now},
	{name: "Loteamento", created_at: datetime_now, updated_at: datetime_now},
	{name: "Morro", created_at: datetime_now, updated_at: datetime_now},
	{name: "Núcleo", created_at: datetime_now, updated_at: datetime_now},
	{name: "Parque", created_at: datetime_now, updated_at: datetime_now},
	{name: "Passarela", created_at: datetime_now, updated_at: datetime_now},
	{name: "Pátio", created_at: datetime_now, updated_at: datetime_now},
	{name: "Praça", created_at: datetime_now, updated_at: datetime_now},
	{name: "Quadra", created_at: datetime_now, updated_at: datetime_now},
	{name: "Recanto", created_at: datetime_now, updated_at: datetime_now},
	{name: "Residencial", created_at: datetime_now, updated_at: datetime_now},
	{name: "Rodovia", created_at: datetime_now, updated_at: datetime_now},
	{name: "Rua", created_at: datetime_now, updated_at: datetime_now},
	{name: "Setor", created_at: datetime_now, updated_at: datetime_now},
	{name: "Sítio", created_at: datetime_now, updated_at: datetime_now},
	{name: "Travessa", created_at: datetime_now, updated_at: datetime_now},
	{name: "Trecho", created_at: datetime_now, updated_at: datetime_now},
	{name: "Trevo", created_at: datetime_now, updated_at: datetime_now},
	{name: "Vale", created_at: datetime_now, updated_at: datetime_now},
	{name: "Vereda", created_at: datetime_now, updated_at: datetime_now},
	{name: "Via", created_at: datetime_now, updated_at: datetime_now},
	{name: "Viaduto", created_at: datetime_now, updated_at: datetime_now},
	{name: "Viela", created_at: datetime_now, updated_at: datetime_now},
	{name: "Vila", created_at: datetime_now, updated_at: datetime_now},
]
AddressType.insert_all(array_AddressType)

array_AddressArea = [
	{name: "Geral", created_at: datetime_now, updated_at: datetime_now},
	{name: "Endereços de entrega", created_at: datetime_now, updated_at: datetime_now},
	{name: "Endereços de saída", created_at: datetime_now, updated_at: datetime_now}
]
AddressArea.insert_all(array_AddressArea)

array_Bank = [
	{number: "001", name: "Banco do Brasil S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "341", name: "Banco Itaú S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "033", name: "Banco Santander (Brasil) S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "356", name: "Banco Real S.A. (antigo)", created_at: datetime_now, updated_at: datetime_now},
	{number: "652", name: "Itaú Unibanco Holding S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "237", name: "Banco Bradesco S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "745", name: "Banco Citibank S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "399", name: "HSBC Bank Brasil S.A. – Banco Múltiplo", created_at: datetime_now, updated_at: datetime_now},
	{number: "104", name: "Caixa Econômica Federal", created_at: datetime_now, updated_at: datetime_now},
	{number: "389", name: "Banco Mercantil do Brasil S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "453", name: "Banco Rural S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "422", name: "Banco Safra S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "633", name: "Banco Rendimento S.A.", created_at: datetime_now, updated_at: datetime_now},
	{number: "756", name: "Sicoob", created_at: datetime_now, updated_at: datetime_now},
	{number: "077", name: "Banco Inter", created_at: datetime_now, updated_at: datetime_now},
	{number: "237", name: "Banco Next", created_at: datetime_now, updated_at: datetime_now},
	{number: "121", name: "Agibank", created_at: datetime_now, updated_at: datetime_now},
	{number: "260", name: "Nuconta (Nubank)", created_at: datetime_now, updated_at: datetime_now},
	{number: "033", name: "Superdigital", created_at: datetime_now, updated_at: datetime_now},
	{number: "637", name: "Sofisa Direto", created_at: datetime_now, updated_at: datetime_now},
	{number: "", name: "Pag!", created_at: datetime_now, updated_at: datetime_now},
	{number: "290", name: "PagBank", created_at: datetime_now, updated_at: datetime_now},
	{number: "735", name: "Banco Neon", created_at: datetime_now, updated_at: datetime_now},
	{number: "655", name: "Votorantim", created_at: datetime_now, updated_at: datetime_now},
]
Bank.insert_all(array_Bank)

array_Sex = [
	{name: "Masculino", created_at: datetime_now, updated_at: datetime_now},
	{name: "Feminino", created_at: datetime_now, updated_at: datetime_now},
	{name: "Não quero informar", created_at: datetime_now, updated_at: datetime_now},
]
Sex.insert_all(array_Sex)

array_PaymentType = [
	{name: "Cartão de crédito", created_at: datetime_now, updated_at: datetime_now},
	{name: "Boleto", created_at: datetime_now, updated_at: datetime_now},
	{name: "Pix", created_at: datetime_now, updated_at: datetime_now}
]
PaymentType.insert_all(array_PaymentType)

array_DataBankType = [
	{name: "Corrente", created_at: datetime_now, updated_at: datetime_now},
	{name: "Poupança", created_at: datetime_now, updated_at: datetime_now},
	{name: "Salário", created_at: datetime_now, updated_at: datetime_now},
]
DataBankType.insert_all(array_DataBankType)

array_SiteContactSubject = [
	{name: "Dúvida", created_at: datetime_now, updated_at: datetime_now},
	{name: "Sugestão", created_at: datetime_now, updated_at: datetime_now},
	{name: "Reclamação", created_at: datetime_now, updated_at: datetime_now},
	{name: "Elogio", created_at: datetime_now, updated_at: datetime_now},
]
SiteContactSubject.insert_all(array_SiteContactSubject)

array_BannerArea = [
	{name: "Página inicial", created_at: datetime_now, updated_at: datetime_now},
	{name: "Produtos", created_at: datetime_now, updated_at: datetime_now},
	{name: "Serviços", created_at: datetime_now, updated_at: datetime_now},
	{name: "Pedidos", created_at: datetime_now, updated_at: datetime_now},
]
BannerArea.insert_all(array_BannerArea)

array_MobileType = [
	{name: "iOS", created_at: datetime_now, updated_at: datetime_now},
	{name: "Android", created_at: datetime_now, updated_at: datetime_now},
	{name: "Outro", created_at: datetime_now, updated_at: datetime_now},
]
MobileType.insert_all(array_MobileType)

array_CategoryType = [
	{name: "Planos", created_at: datetime_now, updated_at: datetime_now},
	{name: "Produtos", created_at: datetime_now, updated_at: datetime_now},
	{name: "Serviços", created_at: datetime_now, updated_at: datetime_now},
]
CategoryType.insert_all(array_CategoryType)

array_Category = [
	{name: "Aerofotogrametria com Drone", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Aerofotogrametria Laser + Drone", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Georreferenciamento Rural e Urbano", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Levantamento Topográfico Planialtimétrico com GPS/Estação Total", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Levantamento Topográfico Planialtimétrico com Laser Scanner", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Perícia Técnica", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Medição de Volumes", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Batimetria", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Levantamento Planialtimétrico Cadastral", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Cadastro Urbano", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Levantamento de Rodovias GPS/Estação Total", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Levantamento de Rodovias Laser Scanner", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "BIM", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Asbuilt (Levantamento Industrial com Laser Scanner)", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
	{name: "Agricultura de Precisão", category_type_id: CategoryType::SERVICOS_ID, created_at: datetime_now, updated_at: datetime_now},
]
Category.insert_all(array_Category)

array_CouponType = [
	{name: "Percentual", created_at: datetime_now, updated_at: datetime_now},
	{name: "Financeiro", created_at: datetime_now, updated_at: datetime_now}
]
CouponType.insert_all(array_CouponType)

array_CouponArea = [
	{name: "Cupom de vendedor", created_at: datetime_now, updated_at: datetime_now},
	{name: "Cupom de desconto", created_at: datetime_now, updated_at: datetime_now}
]
CouponArea.insert_all(array_CouponArea)

array_ProductCondition = [
	{name: "Novo", created_at: datetime_now, updated_at: datetime_now},
	{name: "Usado", created_at: datetime_now, updated_at: datetime_now}
]
ProductCondition.insert_all(array_ProductCondition)

array_RadiusService = [
	{name: "Até 10 km", created_at: datetime_now, updated_at: datetime_now},
	{name: "Até 50 km", created_at: datetime_now, updated_at: datetime_now},
	{name: "Até 200 km", created_at: datetime_now, updated_at: datetime_now},
	{name: "Todo o país", created_at: datetime_now, updated_at: datetime_now}
]
RadiusService.insert_all(array_RadiusService)

FactoryBot.create(:system_configuration, 
	notification_mail: "notificacao@mercadotopografico.com.br",
	contact_mail: "contato@mercadotopografico.com.br",
	page_title: I18n.t("session.project"),
	phone: "(99) 99999-9999",
	cellphone: "(99) 99999-9999",
	page_description: I18n.t("session.project"),
	attendance_data: "Segunda e terça de 09:00 às 18:00"
	)