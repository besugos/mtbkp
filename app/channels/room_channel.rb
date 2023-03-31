class RoomChannel < ApplicationCable::Channel
	
	def subscribed
		if !params[:first_id].nil? && !params[:last_id].nil?
			stream_from "room_channel##{params[:first_id]}##{params[:last_id]}"
		end
	end

	def unsubscribed
	end

	def speak(data)
		message = Message.new(
			content: data['message'], 
			sender_id: data['sender_id'], 
			receiver_id: data['receiver_id'],
			order_id: data['order_id']
			)
		if message.save
			ActionCable.server.broadcast "room_channel##{data['first_id']}##{data['last_id']}", message: message.reload
			User.sending_notification_to_user(data['receiver_id'])
		end
	end
end
