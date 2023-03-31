class CivilState < ApplicationRecord
		
	def as_json(options = {})
		{
			:id => self.id,
			:name => self.name
		}
	end

	SOLTEIRO_ID = 1
	CASADO_ID = 2
	DIVORCIADO_ID = 3
	SEPARADO_ID = 4
	VIUVO_ID = 5
	UNIAO_ESTAVEL_ID = 6
	
end