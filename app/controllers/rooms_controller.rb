class RoomsController < ApplicationController
	
	def show
		@receiver = User.where(id: params[:receiver_id]).first
		if @receiver && policy(@receiver).open_chat?(params[:sender_id])

			@messages = Message.where('(receiver_id = ? AND sender_id = ?) OR (receiver_id = ? AND sender_id = ?)', params[:receiver_id], params[:sender_id], params[:sender_id], params[:receiver_id])
			.limit(50)
			.order('created_at DESC')
			.reverse
					
		else
			flash[:error] = I18n.t('flash.login_error')
			redirect_to root_path
		end
	end

end
