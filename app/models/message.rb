class Message < ApplicationRecord
	acts_as_readable :on => :created_at
	
	after_initialize :default_values
	after_create_commit { MessageBroadcastJob.perform_later self }

	belongs_to :sender, :class_name => 'User'
	belongs_to :receiver, :class_name => 'User'
	belongs_to :admin, :class_name => 'User'
	belongs_to :order

	scope :getting_messages, lambda { |sender_id, receiver_id| where('(receiver_id = ? AND sender_id = ?) OR (receiver_id = ? AND sender_id = ?)', receiver_id, sender_id, sender_id, receiver_id) if !receiver_id.nil? && !receiver_id.blank? && !sender_id.nil? && !sender_id.blank? }
	scope :unread, -> (user) { where('receiver_id = ?', user.id).unread_by(user) }

	validates_presence_of :order_id

	def as_json(options = {})
		{
			:id => self.id,
			:created_at => self.created_at,
			:updated_at => self.updated_at,
			:content => self.content,
			:sender_id => self.sender_id,
			:receiver_id => self.receiver_id,
			:sender => self.sender,
			:receiver => self.receiver,
			:admin => self.admin,
			:admin_id => self.admin_id,
			:order => self.order,
			:order_id => self.order_id,
			:created_at_formatted => CustomHelper.get_text_date(self.created_at, 'datetime', :full),
			:updated_at_formatted => CustomHelper.get_text_date(self.updated_at, 'datetime', :full),
			:created_at_formatted_hour => CustomHelper.get_text_date(self.created_at, 'datetime', :just_hour_minute)
		}
	end

	private

	def default_values
		self.content ||= ''
	end
end
