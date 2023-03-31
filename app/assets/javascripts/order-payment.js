$( document ).ready(function() {

  let BUY_BUTTON = 'payment-button';

  // ID dos campos dos dados do cartão
  let CARD_NAME = 'order_card_attributes_name';
  let CARD_NUMBER = 'order_card_attributes_number';
  let CARD_CCV = 'order_card_attributes_ccv_code';
  let CARD_MONTH = 'order_card_attributes_validate_date_month';
  let CARD_YEAR = 'order_card_attributes_validate_date_year';
  let CARD_BANNER = 'order_card_attributes_card_banner_id';
  let ORDER_CARD_ID = 'order_card_id';
  // Fim dados do cartão

  // Valor a ser pago
  let ORDER_VALUE_TO_BUY = 'order_value_to_buy';

  let PRICE = 'price';
  let PAYMENT_DATA = 'payment-datas'
  let FINISH_BUY = 'finish-payment-data';
  let EDIT_PAYMENT = 'edit-payment-data';

  let ORDER_PAYMENT_TYPE_ID = 'order_payment_type_id';

  // Pega o Sender Hash e o Card Token quando o usuário confirma os dados do cartão
  $("#"+BUY_BUTTON).click(function() {

    let cardName = $("#"+CARD_NAME).val();
    let cardNumber = $("#"+CARD_NUMBER).val();
    let expirationMonth = $("#"+CARD_MONTH).val();
    let expirationYear = $("#"+CARD_YEAR).val();
    let ccv = $("#"+CARD_CCV).val();
    let brand = $("#"+CARD_BANNER).val();
    let order_card_id = $("#"+ORDER_CARD_ID).val();

    if(order_card_id == null || order_card_id == ''){
      if(cardName == '' || cardNumber == '' || expirationMonth == '' || expirationYear == '' || ccv == '' || brand == '' || cardNumber.replace(/ /g,'').length != 16 || ccv.length != 3){
        alert('Preencha corretamente os dados do cartão.');
      } else {
        hideElement(FINISH_BUY, false);
        hideElement(PAYMENT_DATA, true);
      }
    } else {
      hideElement(FINISH_BUY, false);
      hideElement(PAYMENT_DATA, true);
    }
  });

  // Muda do step de finalização para o step de edição do meio de pagamento
  $("#"+EDIT_PAYMENT).click(function() {
    hideElement(FINISH_BUY, true);
    hideElement(PAYMENT_DATA, false);
  });

  let URL_FIND_BY_CARD = '/get_card_details';

  $('#'+ORDER_CARD_ID).on('change', function(){
    let id = $(this).val();
    if(id != null && id != ''){
      $.getJSON(
        URL_FIND_BY_CARD,
        {id: id},
        function(data){
          if(data != null){
            hideElement(FINISH_BUY, false);
            hideElement(PAYMENT_DATA, true);
          } else {
            hideElement(FINISH_BUY, true);
            hideElement(PAYMENT_DATA, false);
          }
        });
    } else {
      hideElement(FINISH_BUY, true);
      hideElement(PAYMENT_DATA, false);
    }
  });

  $('#'+ORDER_PAYMENT_TYPE_ID).on('change', function(){
    let id = $(this).val();
    if(Number(id) == 2 || Number(id) == 3){
      hideElement(FINISH_BUY, false);
      hideElement(PAYMENT_DATA, true);
    } else {
      hideElement(FINISH_BUY, true);
      hideElement(PAYMENT_DATA, false);
    }
  });

})