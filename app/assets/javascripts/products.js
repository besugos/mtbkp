$(document).ready(function() {

	$(document).on('change', '#product_category_id', function(){
		var category_id = $(this).find(":selected").val();
		var select_to_populate = '#product_sub_category_id';
		find_by_category(category_id, select_to_populate);
	});

	$(document).on('change', '#products_grid_category_id', function(){
		var category_id = $(this).find(":selected").val();
		var select_to_populate = '#products_grid_sub_category_id';
		find_by_category(category_id, select_to_populate);
	});

	let DIV_NEW_ADDRESS = "new-address";
	let PRODUCT_SELECTED_ADDRESS_ID = "product_selected_address_id";

	$(document).on('change', '#'+PRODUCT_SELECTED_ADDRESS_ID, function(){
		let value = $(this).val();
		if(value != null && value != ""){
			hideElement(DIV_NEW_ADDRESS, true);
		} else {
			hideElement(DIV_NEW_ADDRESS, false);
		}
	});

	$(document).on('change', '#product_user_id', function(){
		var seller_id = $(this).find(":selected").val();
		var select_to_populate = '#product_selected_address_id';
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

	let PRODUCT_PRICE = "product_price";
	let PRODUCT_PROMOTIONAL_PRICE = "product_promotional_price";

	$(document).on('change', '#'+PRODUCT_PRICE, function(){
		gettingValuesWithTaxes();
	});

	$(document).on('change', '#'+PRODUCT_PROMOTIONAL_PRICE, function(){
		gettingValuesWithTaxes();
	});

	// Busca de valores
	let URL_GET_PRODUCTS_VALUES_WITH_TAX = '/get_products_values_with_tax';

	function gettingValuesWithTaxes(){
		let product_price = $('#'+PRODUCT_PRICE).val();
		let promotional_price = $('#'+PRODUCT_PROMOTIONAL_PRICE).val();
		let correct_price = 0;

		if(promotional_price != null && promotional_price != "" && getMoney(promotional_price) > 0){
			correct_price = promotional_price;
		} else if(product_price != null && product_price != "" && getMoney(product_price) > 0){
			correct_price = product_price;
		}

		$.getJSON(
			URL_GET_PRODUCTS_VALUES_WITH_TAX,
			{
				correct_price: correct_price
			},
			function(data){
				if(data.result){
					insertingValuesInTable(data.values);
				} else {
					alert(data.values);
				}
			});
	}

	function insertingValuesInTable(values){
		for(let i = 0; i < 10; i++){
			$("#payment-value-parcel-"+i).text(values[i].value_formatted);
		}
		$("#payment-value-invoice").text(values[10].value_formatted);
		$("#payment-value-pix").text(values[11].value_formatted);
	}

	let PRODUCT_ADDRESS_ID = 'product_selected_address_id';
    let NEW_ADDRESS = 'new-address';

    $(document).on('change', '#'+PRODUCT_ADDRESS_ID, function(){
        if(this.value == null || this.value == ""){
            hideElement(NEW_ADDRESS, false);
        } else {
            hideElement(NEW_ADDRESS, true);
        }
    });

});