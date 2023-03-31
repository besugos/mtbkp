class DataBankSerializer < ActiveModel::Serializer

	attributes :id,
	:bank_id,
	:bank,
	:data_bank_type_id,
	:data_bank_type,
	:agency,
	:account,
	:operation,
	:cpf_cnpj,
	:pix

end  