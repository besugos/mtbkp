class MessagesController < ApplicationController
	
	def get_old_messages
		sender = User.where(id: params[:sender_id]).first
		receiver = User.where(id: params[:receiver_id]).first

		messages = Message
		.where(sender_id: params[:sender_id])
		.where(receiver_id: params[:receiver_id])
		.limit(params[:limit])
		.order('created_at DESC')

		data = {
			messages: messages
		}
		respond_to do |format|
			format.json {render :json => data, :status => 200}
		end
	end
end
