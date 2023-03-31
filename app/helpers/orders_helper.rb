module OrdersHelper

	def get_users_to_talk
		result = []
		result = User.user.order(:name)
		return result
	end

	def get_users_already_talk
		messages = Message.where("messages.sender_id = ? OR messages.receiver_id = ?", @current_user.id, @current_user.id)
		.order(created_at: :desc)

		users_already_talk = []
		messages.each do |message|

			last_message = Message
			.where("(receiver_id = ? AND sender_id = ?) OR (receiver_id = ? AND sender_id = ?)", message.sender_id, message.receiver_id, message.receiver_id, message.sender_id)
			.last

			current_user = message.sender_id == @current_user.id ? message.receiver : message.sender
			old_user = users_already_talk.select{|item| item[:id] == current_user.id}.first

			if (current_user.id != @current_user.id)
				if old_user.nil?
					data_to_add = {
						id: current_user.id,
						data_message: last_message.created_at,
						data_message_formatted: CustomHelper.get_text_date(last_message.created_at, "datetime", :full),
						user: current_user
					}
					users_already_talk.push(data_to_add)
				else
					if old_user[:data_message] < last_message.created_at
						old_user[:data_message] = last_message.created_at
						old_user[:data_message_formatted] = CustomHelper.get_text_date(last_message.created_at, "datetime", :full)
					end
				end
			end
		end

		users_already_talk = users_already_talk.sort{|item| item[:data_message]}.reverse
		# users_already_talk = users_already_talk.sort_by(&:data_message).reverse

		# receiver_ids = messages.map(&:receiver_id).uniq
		# sender_ids = messages.map(&:sender_id).uniq

		# user_ids = receiver_ids
		# user_ids.concat(sender_ids)
		# user_ids = user_ids.uniq

		# users_already_talk = User.can_chat
		# .where.not(id: [1, @current_user.id])
		# .where(id: [user_ids])
		# .group(:id)

		return users_already_talk
	end

	def getting_time_to_cancel_order(current_order, seller)
		begin
			current_freight_order = current_order.freight_orders.select{|item| item.seller_id == seller.id}.first
			if !current_freight_order.nil? && !current_freight_order.limit_cancel_order.nil?
				limit_cancel_order = current_freight_order.limit_cancel_order
				t = current_freight_order.limit_cancel_order.to_time - DateTime.now.to_time
				mm, ss = t.divmod(60)            
				hh, mm = mm.divmod(60)           
				dd, hh = hh.divmod(24)

				distance_days = dd
				distance_hours = hh
				distance_minutes = mm
			else
				distance_days = ""
				distance_hours = ""
				distance_minutes = ""
				limit_cancel_order = ""
			end
		rescue Exception => e
			Rails.logger.error "-- getting_time_to_cancel_order --"
			Rails.logger.error e.message
			distance_days = ""
			distance_hours = ""
			distance_minutes = ""
			limit_cancel_order = ""
		end
		return [distance_days, distance_hours, distance_minutes, limit_cancel_order]
	end

end
