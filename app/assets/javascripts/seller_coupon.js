$(document).ready(function() {

	var USERS_SELLER_COUPONS_FILTER = 'users_seller_coupons_filter';
	var USERS_SELLER_COUPONS_LINKED = 'users_seller_coupons_linked';

	$("#"+USERS_SELLER_COUPONS_FILTER).on("keyup", function() {
		var value = $(this).val().toLowerCase();
		$("."+USERS_SELLER_COUPONS_LINKED).filter(function() {
			let label_text = $(this).parent().children("label").text();
			if(label_text.toLowerCase().indexOf(value) > -1){
				$(this).toggle(true);
				$(this).parent().toggle(true);
			} else {
				$(this).toggle(false);
				$(this).parent().toggle(false);
			}
		});
	});

});