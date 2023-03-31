$(document).ready(function() {

	var USER_PERSON_TYPE = 'user_person_type_id';

	var DIV_WITH_PERSON_TYPE_PHYSICAL = 'div_with_person_type_physical';
	var DIV_WITH_PERSON_TYPE_JURIDICAL = 'div_with_person_type_juridical';
	
	$(document).on('change', '#'+USER_PERSON_TYPE, function(){
		hideElement(DIV_WITH_PERSON_TYPE_PHYSICAL, true);
		hideElement(DIV_WITH_PERSON_TYPE_JURIDICAL, true);

		if(this.value == 1){
			hideElement(DIV_WITH_PERSON_TYPE_PHYSICAL, false);
		} else if(this.value == 2){
			hideElement(DIV_WITH_PERSON_TYPE_JURIDICAL, false);
		} 
		
	}); 

	let drEvent = $('.dropify').dropify();
	let URL_DESTROY_PROFILE_IMAGE = '/destroy_profile_image';

	drEvent.on('dropify.beforeClear', function(event, element) {
		deleteProfileImage(event, element);
	});

	function deleteProfileImage(event, element){
		let closest_form = $(event.target).closest("form")[0];
		let result = false;
		if(closest_form != null && closest_form.id.includes('edit_user')){
			let user_id = closest_form.id.split('_')[2];
			let confirm = window.confirm('Você tem certeza?');
			if(confirm){
				$.getJSON(
					URL_DESTROY_PROFILE_IMAGE,
					{id: user_id},
					function(data){
						result = data.result;
						if(data.result){
							alert('Imagem removida com sucesso!');
						} else {
							alert('Imagem não removida! Tente novamente!');
						}
					});

			}
		}
	}

	let DIV_DATA_PROFESSIONAL = "div-data-professional";
	let USER_PUBLISH_PROFESSIONAL_PROFILE = "user_publish_professional_profile";

	$(document).on('change', '#'+USER_PUBLISH_PROFESSIONAL_PROFILE, function(){
		let value = $(this).val();
		if(value == "true"){
			hideElement(DIV_DATA_PROFESSIONAL, false);
		} else {
			hideElement(DIV_DATA_PROFESSIONAL, true);
		}
	}); 

});
