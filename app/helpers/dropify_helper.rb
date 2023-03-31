module DropifyHelper

    ##
    # Retorna a URL a ser utilizada no dropify baseado em um atributo do simple_form
    # e da estrutura do arquivo gerado no banco de dados pelo paperclip
    ##
    def dropify_image_url(form_input, obj_attr)

        if form_input.object.persisted? && !form_input.object[obj_attr].nil? && form_input.object[obj_attr].attached?
            return remove_after_char form_input.object[obj_attr].url(:original), '?'
        end

        return ''
    end
end

# End of file dropify_helper.rb
# Path: ./app/helpers/dropify_helper.rb
