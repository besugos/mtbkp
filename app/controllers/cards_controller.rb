class CardsController < ApplicationController
	skip_before_action :authenticate_user
	def get_card_details
		data = Card.where('id = ?', params[:id]).first
		respond_to do |format|
			format.json {render :json => data, :status => 200}
		end
	end
end
