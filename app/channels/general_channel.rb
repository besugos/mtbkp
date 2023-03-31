class GeneralChannel < ApplicationCable::Channel
	
	def subscribed
		if !params[:current_user_id].nil?
			current_user = User.where(id: params[:current_user_id]).first
			stream_from "general_channel##{params[:current_user_id]}"
			User.sending_notification_to_user(current_user.id)
		end
	end

	def unsubscribed
	end

	def speak(data)
		if !data['data']['message_id'].nil?
			receiver = User.where(id: data['current_user_id']).first
			message = Message.where(id: data['data']['message_id']).first
			if receiver && message
				message.mark_as_read! for: receiver
				User.sending_notification_to_user(receiver.id)
			end
		end
	end
end
