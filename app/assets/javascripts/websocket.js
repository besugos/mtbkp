$(document).ready(function() {

	let CURRENT_LOGGED_USER_ID = "#current_logged_user_id";
	let CURRENT_LOGGED_USER_PROFILE_ID = "#current_logged_user_profile_id";

	let USER_CARDS_UNREAD_COUNT = "user-cards-unread-count";
	let USER_CHAT_CARD = "user-chat-card-";
	let WITH_USER_CARDS = "#with-user-cards";

	let FIND_USERS_TO_TALK = 'find_users_to_talk';
	let USER_TO_TALK = 'user-to-talk';

	let RECEIVER_ID = "#receiver_id";
	let SENDER_ID = "#sender_id";
	let CURRENT_USER_ID = "#current_user_id";
	let CURRENT_ORDER_ID = "#current_order_id";

	let ROOM_SPEAKER_CHAT = "room_speaker_chat";
	let DIV_MESSAGES = "div_messages";
	var ROOM_SPEAKER_BEHAVIOR = '[data-behavior~=room_speaker_chat]';
	
	let SELECTED_USER_ID_TO_CHAT = "#selected_user_id_to_chat";

	var SENT_NEW_CHAT_MESSAGE = '#send-new-chat-message';
	var LAST_MESSAGE_DATETIME = 'last-message-datetime';

	checkWebSocketConnection();
	function checkWebSocketConnection(){
		let current_user_id = $(CURRENT_LOGGED_USER_ID).val();
		let profile_id = $(CURRENT_LOGGED_USER_PROFILE_ID).val();
		if(current_user_id != null && current_user_id != "" && profile_id != "2"){
			openGeneralChannel(current_user_id);
		}
	}

	function openGeneralChannel(current_user_id){
		App.room = App.cable.subscriptions.create(
		{
			channel: ("GeneralChannel"),
			current_user_id: current_user_id
		},
		{
			connected: function() {
			},
			disconnected: function() {
			},
			received: function(data) {
				formatScreenByReceiver(data);
			},
			speak: function(current_user_id, data) {
				this.perform('speak', {
					current_user_id: current_user_id,
					data: data
				});
			}
		});
	}

	function formatScreenByReceiver(data){
		if(data != null && data["data"] != null){
			let correct_data = data["data"];
			let current_screen_user_id = null;
			var pathname = window.location.pathname;
			var search = window.location.search;
			if(search.length > 0) {
				current_screen_user_id = parseInt(search.split("=")[1]);
				if(correct_data.unread_messages.find(item => item.user_id == current_screen_user_id)){
					correct_data.unread_chats = (correct_data.unread_chats - 1);
				}
			}
			if(correct_data.unread_chats != null && correct_data.unread_chats > 0){
				hideElement(USER_CARDS_UNREAD_COUNT, false);
				$("#"+USER_CARDS_UNREAD_COUNT).text(correct_data.unread_chats);
				$("#"+USER_CARDS_UNREAD_COUNT).addClass("badge bg-danger");
			} else {
				hideElement(USER_CARDS_UNREAD_COUNT, true);
				$("#"+USER_CARDS_UNREAD_COUNT).text();
				$("#"+USER_CARDS_UNREAD_COUNT).removeClass("badge bg-danger");
			}

			if(correct_data.unread_messages != null && correct_data.unread_messages.length > 0){
				unread_messages = correct_data.unread_messages.sort((a,b) => Date.parse(a.last_message_date) - Date.parse(b.last_message_date))
				for(let i = 0; i < unread_messages.length; i++){
					let current_sender = unread_messages[i];

					let current_sender_messages = current_sender.unread_messages;
					let correct_element_id = USER_CHAT_CARD+correct_data.receiver_id+"-"+current_sender.user_id;
					let element = $("#"+correct_element_id);

					if(element != null){
						$("#"+correct_element_id).remove();
					}
					adjustCardUserChatPosition(current_sender, current_screen_user_id, correct_data.receiver_id);
				}
			}
		}
	}

	function adjustCardUserChatPosition(current_sender, current_screen_user_id, receiver_id){
		$a = $("<a>", {
			"href": current_sender.link_chat, 
			"class": "text-decoration-none user-card",
			"id": USER_CHAT_CARD+receiver_id+"-"+current_sender.user_id
		});

		if(Number(current_screen_user_id) == current_sender.id){
			class_light = "bg-light"
		} else {
			class_light = ""
		}

		$div_border = $("<div>", {"class": "border border-1 "+class_light+" m-2 p-1"});
		$div_col_12 = $("<div>", {"class": "col-12"});
		$image = $("<img>", {"class": "rounded-circle me-1", "width": "50", "height": "50", "src": current_sender.image_url});
		$span_name = $("<span>", {"class": "user-to-talk text-dark fs-14", "text": current_sender.user_name});

		$div_col_12.append($image);
		$div_col_12.append($span_name);
		
		span_class = "";
		if(current_sender.user_id != current_screen_user_id){
			span_class = "badge bg-danger";
		} else {
			current_sender.unread_messages = "";
		}
		$span_message = $("<span>", {
			"class": "mx-1 rounded-circle d-inline-block align-middle "+span_class, 
			"text": current_sender.unread_messages,
			"id": USER_CARDS_UNREAD_COUNT+"-"+receiver_id+"-"+current_sender.user_id,
		});
		$div_col_12.append($span_message);

		$div_text_end = $("<div>", {"class": "text-end"});
		$span = $("<span>", {"class": "fs-10 text-dark mx-1", text: current_sender.last_message_date_formatted});
		$div_text_end.append($span);

		$div_col_12.append($div_text_end);
		$div_border.append($div_col_12);

		$a.append($div_border);

		$(WITH_USER_CARDS).prepend($a);
	}

	$("#"+FIND_USERS_TO_TALK).on("keyup", function() {
		let value = $(this).val().toLowerCase();
		$("."+USER_TO_TALK).filter(function() {
			let current_name = $(this).text();
			if($(this).text().toLowerCase().indexOf(value) > -1){
				$(this).parent().parent().show();
			} else {
				$(this).parent().parent().hide();
			}
		});
	});

	$(document).on('click', SENT_NEW_CHAT_MESSAGE, function(event) {
		let text_message = $(ROOM_SPEAKER_BEHAVIOR).val();
		sendMessage(text_message);
	});

	function sendMessage(text_message){
		if(App.cable.subscriptions.subscriptions.length > 0){
			let room = App.cable.subscriptions.subscriptions.find(item => item.identifier.includes("RoomChannel"));
			if(room != null && !isTextMessageEmpty(text_message)){
				room.speak(text_message);
				text_message = '';
				$(ROOM_SPEAKER_BEHAVIOR).val("");
				$(ROOM_SPEAKER_BEHAVIOR).text("");
			}
		}
	}

	function isTextMessageEmpty(text_message){
		return (text_message == null || text_message == '' || text_message.split(' ').join('').length == 0 || text_message.length == 0)
	}

	messageContainerScrollBottom();
	/**
	* Send user to the bottom of message container
	*/
	function messageContainerScrollBottom() {
		let messageContainer = document.getElementById('message-container');
		if (messageContainer == null) return;
		messageContainer.scrollTop = messageContainer.scrollHeight;
	}

	checkChatScreen();
	function checkChatScreen(){
		var pathname = window.location.pathname;
		if(pathname.includes('/chats')) {
			openChannelChat();
		}
	}

	function getArrayUser(){
		var user_id_1 = $(RECEIVER_ID).val();
		var user_id_2 = $(SENDER_ID).val();
		return [user_id_1, user_id_2].sort(function(a, b){return a - b});
	}

	function openChannelChat(){
		var users = getArrayUser();
		if(users.length == 2){
			App.room = App.cable.subscriptions.create(
			{
				channel: ("RoomChannel"),
				first_id: users[0],
				last_id: users[1]
			},
			{
				connected: function() {
				},
				disconnected: function() {
				},
				received: function(data) {
					addNewMessage(data);
				},
				speak: function(message) {
					this.perform('speak', {
						message: message,
						receiver_id: $(RECEIVER_ID).val(),
						sender_id: $(SENDER_ID).val(),
						order_id: $(CURRENT_ORDER_ID).val(),
						first_id: users[0],
						last_id: users[1]
					});
				}
			});
		}
	}

	$(document).on('keypress', '[data-behavior~='+ROOM_SPEAKER_CHAT+']', function(event) {
		if (event.keyCode === 13) {
			if(event.target.value != null && event.target.value != ''){
				sendMessage(event.target.value);
			}
			return event.preventDefault();
		}
	});

	// $(document).on('change', SELECTED_USER_ID_TO_CHAT, function(event) {
	// 	let value = $(this).find(":selected").val();
	// 	if(value != null && value != ""){
	// 		window.location = "/chats?user_id="+value;
	// 	}
	// });

	function addNewMessage(data){
		if(data != null && data.message != null){
			let correct_name = "";
			let div_class = "";
			let span_class = "";
			let current_user_id = $(CURRENT_USER_ID).val();
			let current_user_to_get = "";
			let message = data.message;

			if(parseInt(current_user_id) == parseInt(message.sender_id)){
				div_class = 'float-end';
				span_class = 'text-white btn-primary box-message-right';
				current_user_to_get = message.sender;
				if(current_user_to_get.profile_id == 1 || current_user_to_get.profile_id == 4){
					correct_name = current_user_to_get.name;
				} else if(current_user_to_get.profile_id == 3){
					correct_name = current_user_to_get.social_name;
				}
			} else {
				div_class = 'float-start';
				span_class = 'btn-secondary box-message-left';
				current_user_to_get = message.sender;
				if(current_user_to_get.profile_id == 1 || current_user_to_get.profile_id == 4){
					correct_name = current_user_to_get.name;
				} else if(current_user_to_get.profile_id == 3){
					correct_name = current_user_to_get.social_name;
				}
			}

			let $div_row = $("<div>", {"class": "row my-1"});
			let $div_col = $("<div>", {"class": "col-12"});
			let $div_py = $("<div>", {"class": "py-1 "+div_class});
			let $span = $("<span>", {"class": "btn "+span_class+" "+div_class, "text": message.content});
			let $span_hour = $("<span>", {"class": "fs-10 "+div_class, "text": " "+message.created_at_formatted});
			let $br = $("<br>");

			$div_py.append($span);
			$div_py.append($br);
			$div_py.append($span_hour);
			$div_col.append($div_py);
			$div_row.append($div_col);
			
			$('#'+DIV_MESSAGES).append($div_row);

			messageContainerScrollBottom();
			settingReadAfterReceiveMessage(current_user_id, message);

			$('.'+LAST_MESSAGE_DATETIME).text(message.created_at_formatted).html(message.created_at_formatted);
		}
	}

	function settingReadAfterReceiveMessage(current_user_id, message){
		if(parseInt(current_user_id) == parseInt(message.receiver.id)){
			if(App.cable.subscriptions.subscriptions.length > 0){
				let room = App.cable.subscriptions.subscriptions.find(item => item.identifier.includes("GeneralChannel"));
				if(room != null){
					data = {
						message_id: message.id
					}
					room.speak(current_user_id, data);
				}
			}
		}
	}

	
});
