class Phone < ActiveRecord::Base
	belongs_to :ownertable, :polymorphic => true
	belongs_to :phone_type

	validates_presence_of :phone

	def as_json(options = {})
		{
			:id => self.id,
			:phone_code => self.phone_code,
			:phone => self.phone,
			:responsible => self.responsible,
			:phone_type_id => self.phone_type_id,
			:phone_type => self.phone_type,
			:is_whatsapp => self.is_whatsapp,
			:phone_formatted => self.get_phone_formatted
		}
	end

	def get_phone_formatted
		text = ''
		if !self.phone_code.nil? && !self.phone_code.blank?
			text += self.phone_code
			text += ' '
		end
		if !self.phone.nil?
			text += self.phone
		end
		return text
	end
	
end
