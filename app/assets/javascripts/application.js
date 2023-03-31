// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require @popperjs/core/dist/umd/popper.min
//= require bootstrap/dist/js/bootstrap.min
//= require jquery/dist/jquery.min
//= require jquery/dist/jquery.min
//= require dropify/dist/js/dropify.min
//= require select2/dist/js/select2.full.min
//= require select2/dist/js/i18n/pt-BR
//= require jquery-mask-plugin/dist/jquery.mask.min
//= require bootstrap-datepicker/dist/js/bootstrap-datepicker
//= require bootstrap-datepicker/dist/locales/bootstrap-datepicker.pt-BR.min
//= require inputmask/dist/jquery.inputmask.bundle
//= require jquery-maskmoney/dist/jquery.maskMoney.min
//= require jquery-ujs/src/rails
//= require swiper/swiper-bundle.min
//= require moment/min/moment-with-locales.min
//= require jquery-validation/dist/jquery.validate.min
//= require jquery-validation/dist/additional-methods.min
//= require jquery-validation/dist/localization/messages_pt_BR.min
//= require flatpickr/dist/flatpickr.min
//= require flatpickr/dist/l10n/pt
//= require action_cable
//= require_tree .

const settings = {
  flatpickr: {
    locale: 'pt',
    monthSelectorType: 'static',
    enableTime: true,
    disableMobile: true,
    dateFormat: 'd/m/Y H:i'
  }
}

$(document).ready( () => {

  /**
   * Aqui nós vamos ativar todo ou qualquer componente "toast"
   * do bootstrap que exita no HTML
   * Existe uma view específica para renderizar o componente com apoio do flash do Rails
   *
   * Veja a documentação do componente: https://getbootstrap.com/docs/4.3/components/toasts
   */
   $('.toast').toast('show');

  // Trocar icone + por -
  $('.form-panel').on('hidden.bs.collapse', toggleIcon);
  $('.form-panel').on('shown.bs.collapse', toggleIcon);

  // Habilita os tooltips do Bootstrap em todo o projeto
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

  // Configurar gritter, caso seja necessário.
  // $.extend($.gritter.options, {
  //  fade_out_speed: 2000, // how fast the notices fade out
  //  time: 1000 // hang on the screen for...
  // });

  $('.no-space').keydown(function(event) {
    if(event.which == 32)
      return false;
  });

  $('.change_locale').on('change', function () {
    window.location = '/update_locale/'+this.id;
  });

  $(document).keydown(function(event) {
    let keyCode = (event.keyCode ? event.keyCode : event.which);
    if (keyCode == 13) {
      if($(document.activeElement) != null && $(document.activeElement).hasClass('cep')){
        nextFocus();
        return false;
      }
    }
  });

  function nextFocus(){
    let focussableElements = 'a:not([disabled]), button:not([disabled]), input[type=text]:not([disabled]), [tabindex]:not([disabled]):not([tabindex="-1"])';
    if (document.activeElement && document.activeElement.form) {
      let focussable = Array.prototype.filter.call(document.activeElement.form.querySelectorAll(focussableElements),
        function (element) {
        //check for visibility while always include the current activeElement
        return element.offsetWidth > 0 || element.offsetHeight > 0 || element === document.activeElement
      });
      let index = focussable.indexOf(document.activeElement);
      if(index > -1) {
        let nextElement = focussable[index + 1] || focussable[0];
        nextElement.focus();
      }
    }
  }

  /**
    Exemplo no model de PRODUCT
    <%= f.association :category,
    collection: Category.order(:name),
    as: :select, include_blank: t("model.select_option"),
    label_method: :get_html_text,
    input_html: {class: 'select2icon'} %>
  */
  $(".select2icon").select2({
    escapeMarkup: function (markup) { return markup; }
  });

  getLocation();
  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition);
    } else {
      console.log("Geolocation is not supported by this browser.");
    }
  }

  function showPosition(position) {
    let latitude = position.coords.latitude;
    let longitude = position.coords.longitude;
    if(latitude != null && latitude != '' && longitude != null && longitude != ''){
      $.ajax({
        url: "/update_current_position",
        dataType: 'json',
        data: {
          latitude: latitude,
          longitude: longitude
        },
        async: false,
        success: function(data) {
        }
      });
    }
      // console.log("Lat: "+position.coords.latitude+" / Lng: "+position.coords.longitude);
  }
  
  // encrypt_card();
  // function encrypt_card() {
  //   var card = PagSeguro.encryptCard({
  //     publicKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr+ZqgD892U9/HXsa7XqBZUayPquAfh9xx4iwUbTSUAvTlmiXFQNTp0Bvt/5vK2FhMj39qSv1zi2OuBjvW38q1E374nzx6NNBL5JosV0+SDINTlCG0cmigHuBOyWzYmjgca+mtQu4WczCaApNaSuVqgb8u7Bd9GCOL4YJotvV5+81frlSwQXralhwRzGhj/A57CGPgGKiuPT+AOGmykIGEZsSD9RKkyoKIoc0OS8CPIzdBOtTQCIwrLn2FxI83Clcg55W8gkFSOS6rWNbG5qFZWMll6yl02HtunalHmUlRUL66YeGXdMDC2PuRcmZbGO5a/2tbVppW6mfSWG3NPRpgwIDAQAB",
  //     holder: "Nome Sobrenome",
  //     number: "424242424243499",
  //     expMonth: "12",
  //     expYear: "2030",
  //     securityCode: "123"
  //   });
  //   var encrypted = card.encryptedCard;
  //   console.log(card);
  //   console.log(encrypted);
  // }

});

function toggleIcon(e) {
  $(e.target)
  .prev('.panel-heading')
  .find(".more-less")
  .toggleClass('fa-plus fa-minus');
}


function hideElement(object, hide){
  if(hide){
    $('#'+object).hide();
    $('#'+object).attr("hidden","true");
    $('.'+object).hide();
    $('.'+object).attr("hidden","true");
  } else {
    $('#'+object).show();
    $('#'+object).removeAttr('hidden');
    $('.'+object).show();
    $('.'+object).removeAttr('hidden');
  }
}

function disableElement(element, disable){
  $('#'+element).prop( "readOnly", disable);
  $('#'+element).prop("disabled", disable);
  $('.'+element).prop( "readOnly", disable);
  $('.'+element).prop("disabled", disable);
  if(disable){
    $('#'+element).addClass("disabled");
    $('.'+element).addClass("disabled");
  } else {
    $('#'+element).removeClass("disabled");
    $('.'+element).removeClass("disabled");
  }
}

/* Formatar Dinheiro */
function formatToCurrency(val){
  if(isNaN(val)){
    val = 0;
  }
  return "R$ "+Math.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
}

/* Buscar valor em integer recebendo valor em dinheiro formatado */
function getMoney( str )
{
  return parseInt( str.replace(/[\D]+/g,'') );
}

/* Preencher select com as opções enviadas por parâmetro
  values: array de opções
  select_to_populate: id do select que receberá as opções
  attribute: qual será o atributo de texto da opção (name, fantasy_name, etc)
  value_to_select: caso possua um valor a já ser selecionado
  */
  function fillSelect(values, select_to_populate, attribute, value_to_select, text_select){
    let option_template = '<option :selected value=":id">:text</option>';
    let options = [];
    options.push(option_template.replace(':id', "").replace(':text', text_select).replace(':selected', ""));

    $.each(values, function (index, current) {
      selected = ""
      if (current.id == value_to_select) {
        selected = "selected"
      }
      options.push(option_template.replace(':id', current.id).replace(':text', current[attribute]).replace(':selected', selected));
    });
    $(select_to_populate).html(options.join(''));
    $(select_to_populate).select2();
  }

  let URL_FIND_CEP = '/find_cep';
  let URL_FIND_BY_STATE = '/states/:state_id/cities.json';
  let URL_FIND_BY_COUNTRY = '/countries/:country_id/states.json';

  // Preenchendo os dados corretos nos campos de endereço após a busca pelo CEP
  function fill_values_after_cep_find(data, address_id, district_id, selectState, state_id, city_id){
    $('#'+address_id).val(data.address.address);
    $('#'+district_id).val(data.address.neighborhood);

    $("#"+state_id).find("option").filter(function(index) {
      return selectState === $(this).text();
    }).prop("selected", "selected");
    $('#'+state_id).select2();

    let selectCity = data.address.city;
    $("#"+city_id).find("option").filter(function(index) {
      return selectCity === $(this).text();
    }).prop("selected", "selected");
    $('#'+city_id).select2();
  }

  // Buscar todas as cidades de um Estado
  function find_by_state(state_id, select_to_populate){
    let url = URL_FIND_BY_STATE.replace(':state_id', state_id);
    $.getJSON(url, function (values) {
      fillSelect(values, select_to_populate, 'name', null, '-- Selecione um opção --');
    });
  }

  // Buscar todas as cidades de um Estado
  function find_by_country(country_id, select_to_populate){
    let url = URL_FIND_BY_COUNTRY.replace(':country_id', country_id);
    $.getJSON(url, function (values) {
      fillSelect(values, select_to_populate, 'name', null, '-- Selecione um opção --');
    });
  }

  // Buscar o endereço completo baseado no cep
  function find_by_cep(cep, address_id, district_id, state_id, city_id){
    if(cep != null && cep != ''){
      $.ajax({
        url: URL_FIND_CEP,
        dataType: 'json',
        async: false,
        data: {
          cep: cep
        },
        success: function(data) {
          let selectState = data.address.state
          fill_values_after_cep_find(data, address_id, district_id, selectState, state_id, city_id);
        }
      });
    }
  }

  // Busca por subcategorias
  let URL_FIND_BY_CATEGORY = '/get_subcategories/:category_id';
  function find_by_category(category_id, select_to_populate){
    let url = URL_FIND_BY_CATEGORY.replace(':category_id', category_id);
    $.getJSON(url, function (data) {
      fillSelect(data.result, select_to_populate, 'name', null, '-- Selecione um opção --');
    });
  }

  // Copiando texto de um input
  function copyInputTextToClipboard(text_id) {
    /* Get the text field */
    var copyText = document.getElementById(text_id);

    /* Select the text field */
    copyText.select();
    copyText.setSelectionRange(0, 99999); /* For mobile devices */

    /* Copy the text inside the text field */
    document.execCommand("copy");

    /* Alert the copied text */
    alert("Copiado com sucesso!");
  }

// End of file application.js
// Path: ./app/assets/javascripts/application.js
