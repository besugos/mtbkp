$(document).ready(function(){

    let FILTER_SERVICES_BY_DATA = "filter-services-by-data";

    let NEXT_STEP = "next-step";
    let BACK_STEP = "back-to-step";

    $('#'+FILTER_SERVICES_BY_DATA).validate({
        onfocusout: function(element) {
            this.element(element);  
        },
        errorPlacement: function(error, element) {
            if (element.attr("name") == 'service_goal_id')
                error.insertAfter(".custom-error-service_goal_id");
            else if (element.attr("name") == 'service_ground_id')
                error.insertAfter(".custom-error-service_ground_id");
            else if (element.attr("name") == 'service_ground_type_id')
                error.insertAfter(".custom-error-service_ground_type_id");
            else
                error.insertAfter(element);
        },
        rules: {
            'service_goal_id': {
                required: true
            },
            'service_ground_id': {
                required: true
            },
            'service_ground_type_id': {
                required: true
            },
        },
        messages: {
            'service_goal_id': {
                required: 'Campo obrigatório'
            },
            'service_ground_id': {
                required: 'Campo obrigatório'
            },
            'service_ground_type_id': {
                required: 'Campo obrigatório'
            },
        }
    });

    $(document).on('click', '.'+NEXT_STEP, function(){
        let next_step = this.id.split("-")[3];
        validateFields(next_step);
    });

    $(document).on('click', '.'+BACK_STEP, function(){
        let back_step = this.id.split("-")[3];
        backStep(back_step);
    });

    function validateFields(next_step){
        let valid = false;
        if(Number(next_step) == 2){
            valid = $('#'+FILTER_SERVICES_BY_DATA).validate().element("#service_goal_id");
        } else if(Number(next_step) == 3){
            valid = $('#'+FILTER_SERVICES_BY_DATA).validate().element("#service_ground_id");
        } else if(Number(next_step) == 4){
            valid = $('#'+FILTER_SERVICES_BY_DATA).validate().element("#service_ground_type_id");
        } else if(Number(next_step) == 5){

        }

        console.log(next_step);

        if(valid){
            if(Number(next_step) == 2){
                hideElement("service_step_1", true);
                hideElement("service_step_2", false);
                hideElement("service_step_3", true);
                hideElement("service_step_4", true);
                $("#form-service-bar").css("width", "25%");
            } else if(Number(next_step) == 3){
                hideElement("service_step_1", true);
                hideElement("service_step_2", true);
                hideElement("service_step_3", false);
                hideElement("service_step_4", true);
                $("#form-service-bar").css("width", "50%");
            } else if(Number(next_step) == 4){
                hideElement("service_step_1", true);
                hideElement("service_step_2", true);
                hideElement("service_step_3", true);
                hideElement("service_step_4", false);
                $("#form-service-bar").css("width", "75%");
            } else if(Number(next_step) == 5){

            }
        }
    }

    function backStep(back_step){
        let valid = false;
        if(Number(back_step) == 1){
            hideElement("service_step_1", false);
            hideElement("service_step_2", true);
            hideElement("service_step_3", true);
            hideElement("service_step_4", true);
            $("#form-service-bar").css("width", "0%");
        } else if(Number(back_step) == 2){
            hideElement("service_step_1", true);
            hideElement("service_step_2", false);
            hideElement("service_step_3", true);
            hideElement("service_step_4", true);
            $("#form-service-bar").css("width", "25%");
        } else if(Number(back_step) == 3){
            hideElement("service_step_1", true);
            hideElement("service_step_2", true);
            hideElement("service_step_3", false);
            hideElement("service_step_4", true);
            $("#form-service-bar").css("width", "50%");
        }
    }

    let SERVICE_ADDRESS_ID = 'service_selected_address_id';
    let NEW_ADDRESS = 'new-address';

    $(document).on('change', '#'+SERVICE_ADDRESS_ID, function(){
        if(this.value == null || this.value == ""){
            hideElement(NEW_ADDRESS, false);
        } else {
            hideElement(NEW_ADDRESS, true);
        }
    });

});