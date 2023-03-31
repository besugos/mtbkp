$(document).ready(function() {

	$(document).on('change', '#service_category_id', function(){
		var category_id = $(this).find(":selected").val();
		var select_to_populate = '#service_sub_category_id';
		find_by_category(category_id, select_to_populate);
	});

	$(document).on('change', '#services_grid_category_id', function(){
		var category_id = $(this).find(":selected").val();
		var select_to_populate = '#services_grid_sub_category_id';
		find_by_category(category_id, select_to_populate);
	});

	let DIV_NEW_ADDRESS = "new-address";
	let SERVICE_SELECTED_ADDRESS_ID = "service_selected_address_id";

	$(document).on('change', '#'+SERVICE_SELECTED_ADDRESS_ID, function(){
		let value = $(this).val();
		if(value != null && value != ""){
			hideElement(DIV_NEW_ADDRESS, true);
		} else {
			hideElement(DIV_NEW_ADDRESS, false);
		}
	}); 

	$(document).on('change', '#service_user_id', function(){
		var seller_id = $(this).find(":selected").val();
		var select_to_populate = '#service_selected_address_id';
		find_by_seller(seller_id, select_to_populate);
	});

	// Busca por vendedor
	let URL_FIND_BY_SELLER = '/get_addresses_by_seller/:seller_id';
	function find_by_seller(seller_id, select_to_populate){
		let url = URL_FIND_BY_SELLER.replace(':seller_id', seller_id);
		$.getJSON(url, function (data) {
			fillSelect(data.result, select_to_populate, 'name', null, 'Novo endereço');
		});
	}

});