class Email < ActiveRecord::Base
	belongs_to :ownertable, :polymorphic => true
	belongs_to :email_type

	validates_presence_of :email

	def as_json(options = {})
		{
			:id => self.id,
			:email => self.email,
			:email_type_id => self.email_type_id,
			:email_type => self.email_type
		}
	end

	def self.address_valid?(email)
		address = ValidEmail2::Address.new(email)
		return (address.valid? && address.valid_mx?)
	end
end
