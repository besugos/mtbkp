$(document).ready(function() {

	let CHANGE_QUANTITY_PRODUCT = 'change_quantity_product';
	let CHANGE_ADDRESS_TO_ORDER = 'change_address_to_order';
	let INSERT_SELLER_COUPON = 'insert-seller-coupon';
	let TEXT_SELLER_COUPON = '#text-seller-coupon';
	let CURRENT_ORDER_TO_PAY_ID = '#current_order_to_pay_id';

	let URL_INSERT_SELLER_COUPON_TO_ORDER = '/insert_seller_coupon';
	let SHOW_ADDRESS_DATA = 'show_address_data';
	let ORDER_ADDRESS_ATTRIBUTES_ZIPCODE = 'order_address_attributes_zipcode';
	let ORDER_ADDRESS_ATTRIBUTES_ADDRESS = 'order_address_attributes_address';
	
	let ORDER_ADDRESS_ID = 'order_address_id';
	let ORDER_ADDRESS = 'order-address';

	checkGetAddressByZipcode();
	function checkGetAddressByZipcode(){
		var pathname = window.location.pathname;
		if((pathname.includes('/pay_order'))) {
			let address_screen = $("#"+SHOW_ADDRESS_DATA);
			if(address_screen.length == 1){
				let zipcode = $("#"+ORDER_ADDRESS_ATTRIBUTES_ZIPCODE).val();
				let address = $("#"+ORDER_ADDRESS_ATTRIBUTES_ADDRESS).val();
				if((zipcode != null && zipcode != "") && (address == null || address == "")){
					find_by_cep(zipcode, 'order_address_attributes_address', 
						'order_address_attributes_district', 
						'order_address_attributes_state_id', 
						'order_address_attributes_city_id');
				}
			}
		}
	}
	
	$(document).on('change', '.'+CHANGE_QUANTITY_PRODUCT, function(){
		$(this).closest('form').submit();
	});
	
	$(document).on('change', '.'+CHANGE_ADDRESS_TO_ORDER, function(){
		if(this.value != null && this.value != ""){
			$(this).closest('form').submit();
		}
	});
	
	$(document).on('change', '#'+ORDER_ADDRESS_ID, function(){
		if(this.value == null || this.value == ""){
			hideElement(ORDER_ADDRESS, false);
		} else {
			hideElement(ORDER_ADDRESS, true);
		}
	});
	
	$(document).on('click', '#'+INSERT_SELLER_COUPON, function(){
		insertSellerCoupon();
	});

	function insertSellerCoupon(){
		let text_seller_coupon = $(TEXT_SELLER_COUPON).val();
		let current_order_to_pay_id = $(CURRENT_ORDER_TO_PAY_ID).val();

		if(text_seller_coupon != null && text_seller_coupon != ""){
			if(current_order_to_pay_id != null && current_order_to_pay_id != ""){
				$.getJSON(
					URL_INSERT_SELLER_COUPON_TO_ORDER,
					{
						current_order_to_pay_id: current_order_to_pay_id,
						text_seller_coupon: text_seller_coupon
					},
					function(data){
						alert(data.message);
						if(data.result){
							window.location = window.location;
						}
					});
			}
		} else {
			alert("Insira o texto do cupom");
		}
	}

	let URL_ADD_ITEM_TO_ORDER = "/add_item_to_order";
	let CURRENT_PRODUCT_ID = "current_product_id";
	let ADD_PRODUCT_TO_CART = "add-product-to-cart";
	let PRODUCT_QUANTITY_STOCK = "product-quantity-stock";
	let QUANTITY_PRODUCT_CALCULATE = "quantity-product-calculate";

	$(document).on('click', '#'+ADD_PRODUCT_TO_CART, function(){
		addProductToCart();
	});

	function addProductToCart() {
		let quantity_stock = Number($("#"+PRODUCT_QUANTITY_STOCK).val());
		let quantity_to_add = Number($("#"+QUANTITY_PRODUCT_CALCULATE).val());

		if(quantity_to_add <= quantity_stock){
			let product_id = $("#"+CURRENT_PRODUCT_ID).val();
			$.getJSON(
				URL_ADD_ITEM_TO_ORDER,
				{
					ownertable_type: "Product",
					ownertable_id: product_id,
					quantity: quantity_to_add
				},
				function(data){
					alert(data.message);
					if(data.result){
						window.location = "/show_order_cart";
					}
				});
		} else {
			alert("Quantidade acima do estoque atual.");
		}
	}

	let URL_INSERT_DISCOUNT_COUPON_TO_ORDER = '/insert_discount_coupon';
	let INSERT_DISCOUNT_COUPON = 'insert-discount-coupon';
	let TEXT_DISCOUNT_COUPON = '#text-discount-coupon';
	
	$(document).on('click', '#'+INSERT_DISCOUNT_COUPON, function(){
		insertDiscountCoupon();
	});

	function insertDiscountCoupon(){
		let text_discount_coupon = $(TEXT_DISCOUNT_COUPON).val();
		let current_order_to_pay_id = $(CURRENT_ORDER_TO_PAY_ID).val();

		if(text_discount_coupon != null && text_discount_coupon != ""){
			if(current_order_to_pay_id != null && current_order_to_pay_id != ""){
				$.getJSON(
					URL_INSERT_DISCOUNT_COUPON_TO_ORDER,
					{
						current_order_to_pay_id: current_order_to_pay_id,
						text_discount_coupon: text_discount_coupon
					},
					function(data){
						alert(data.message);
						if(data.result){
							window.location = window.location;
						}
					});
			}
		} else {
			alert("Insira o texto do cupom");
		}
	}

	let URL_GET_FREIGHT_VALUES = '/get_freight_values';
	let SEARCH_FREIGHT_ZIPCODE_CALCULATE_ORDER_CART = "search-freight-zipcode-calculate-order-cart";
	let FREIGHT_ZIPCODE_CALCULATE_ORDER_CART = "freight-zipcode-calculate-order-cart";

	$(document).on('click', '#'+SEARCH_FREIGHT_ZIPCODE_CALCULATE_ORDER_CART, function(){
		findFreightValues();
	});

	function findFreightValues(){
		let postalcode_to = $("#"+FREIGHT_ZIPCODE_CALCULATE_ORDER_CART).val();
		let current_order_to_pay_id = $(CURRENT_ORDER_TO_PAY_ID).val();
		if(postalcode_to != null && postalcode_to != ""){
			$.getJSON(
				URL_GET_FREIGHT_VALUES,
				{
					postalcode_to: postalcode_to,
					id: current_order_to_pay_id
				},
				function(data){
					if(data.result){
						window.location = window.location;
					}
				});
		} else {
			alert("Digite um CEP válido");
		}
	}

	let URL_UPDATING_FREIGHT_SELECT = '/updating_freight_select';
	let FORM_SHOW_CURRENT_ORDER = ".form-show-current-order";
	let FORM_EDIT_ORDER = ".edit_order";
	let FREIGHT_ORDER_OPTION = "freight_order_option";
	$(document).on('click', '.'+FREIGHT_ORDER_OPTION, function(){
		updateSelectedFreight(this);
	});

	function updateSelectedFreight(selected){
		let position_group = selected.id.split("_")[3];
		$("."+FREIGHT_ORDER_OPTION+"_"+position_group).prop("checked", false);
		$("."+FREIGHT_ORDER_OPTION+"_"+position_group).attr("checked", false);
		$("."+FREIGHT_ORDER_OPTION+"_"+position_group).val(false);
		let current_order_to_pay_id = $(CURRENT_ORDER_TO_PAY_ID).val();
		$.getJSON(
			URL_UPDATING_FREIGHT_SELECT,
			{
				freight_order_id: position_group,
				id: current_order_to_pay_id
			},
			function(data){
				if(data.result){
					$(selected).attr("checked", true);
					$(selected).prop("checked", true);
					$(selected).val(true);
					$(FORM_SHOW_CURRENT_ORDER).submit();
					if($(FORM_SHOW_CURRENT_ORDER).length == 0){
						if($(FORM_EDIT_ORDER).length > 0){
							$(FORM_EDIT_ORDER).submit();
						}
					} else {
						$(FORM_SHOW_CURRENT_ORDER).submit();
					}
				}
			});
	}

	let CHANGE_SELECTION_START = 'change-selection-start';
	let START_POSITION = '-start-position-';

	$(document).on('click', '.'+CHANGE_SELECTION_START, function(){
		let current_class = $(this).attr('class').split(' ')[0];
		let current_professional_id = current_class.split("-")[0];
		let current_order_id = current_class.split("-")[1];
		let current_input = current_class.split("-")[2];
		let position = Number(this.id.split('-')[5]);
		for (let i = 0; i <= position; i++){
			$('#'+current_class+START_POSITION+i).removeClass('bi-star');
			$('#'+current_class+START_POSITION+i).addClass('bi-star-fill');
		}
		for (let i = 5; i > position; i--){
			$('#'+current_class+START_POSITION+i).removeClass('bi-star-fill');
			$('#'+current_class+START_POSITION+i).addClass('bi-star');
		}
		$('#avaliation_'+current_input+"_"+current_professional_id+"-"+current_order_id).val(position);
	});

	let SHOW_CANCEL_FORM = 'show-cancel-form';
	let DIV_CANCEL_ORDER = 'div-cancel-order-';

	$(document).on('click', '.'+SHOW_CANCEL_FORM, function(){
		let id = this.id.split("-")[3];
		let element = document.getElementById(DIV_CANCEL_ORDER+id);
		console.log(element);
		if (element.style.display === "none") {
			element.style.display = 'block';
		} else {
			element.style.display = 'none';
		}
	});

});
