class Profile < ActiveRecord::Base
	ADMIN = "Administrador"
	USER = "Usuário"

	ADMIN_ID = 1
	USER_ID = 2
	
	has_many :users
	validates_presence_of :name

	def as_json(options = {})
		{
			:id => self.id,
			:name => self.name
		}
	end

	def admin?
		self.id == Profile::ADMIN_ID
	end

	def user?
		self.id == Profile::USER_ID
	end

	def to_s
		name
	end
end
