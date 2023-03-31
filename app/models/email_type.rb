class EmailType < ApplicationRecord
	validates_presence_of :name

	def as_json(options = {})
		{
			:id => self.id,
			:name => self.name
		}
	end
	
end
