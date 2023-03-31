/*
* REGRAS:
* - a div a ser clonada deverá ter a classe multi-nome
* - a div deverá ter o hidden multi-nome-cont começando com zero
* - o botão de adicionar terá a classe multi-nome-add
* - o botão de deletar terá a classe multi-nome-del
*/

function multi(nome, enableDel){
    var item      = '.multi-' + nome;
    var addButton = '.multi-' + nome + '-add';
    var delButton = '.multi-' + nome + '-del';
    var contEl    = '.multi-' + nome + '-cont';

    //ao clicar no botão de adicionar
    $(document).on('click', addButton, function(){
        //incrementa-se o cont
        var cont = $(contEl).val();
        cont++;
        $(contEl).val(cont);

        //clona-se a div
        var clone = $(item).last().clone();

        //pra cada input, select e textarea
        clone.find('input, select, textarea, checkbox, label').each(function(index, el) {
            
            if($(this).is("label")) {
                // Atualizando o atributo for
                let new_for = $(this).attr("for").replace($(this).attr("for").match("[0-9]"), cont);
                $(this).attr("for", new_for);
            } else {
                //muda-se o id e o nome
                this.name = this.name.replace(this.name.match("[0-9]"), cont);
                this.id = this.id.replace(this.id.match("[0-9]"), cont);
                
                if( $(this).hasClass('complete-phone-ddd') ){
                    $(this).unmask();
                    $(this).inputmask({
                        mask: ["(99) 9999-9999", "(99) 99999-9999" ],
                        keepStatic: true
                    });
                } else if( $(this).hasClass('money') ){
                    $(this).unmask();
                    $(this).mask("000.000.000.000,00", {reverse: true});
                }  else if ($(this).hasClass('chosen') || $(this).hasClass('select2') || $(this).hasClass('select')) {
                    $(this).select2();
                    $(this).val('').trigger('change');
                    $(this).next().next().remove();
                } else if( $(this).hasClass('cep') ){
                    $(this).unmask();
                    $(this).inputmask({
                        mask: "99.999-999",
                        keepStatic: true,
                        positionCaretOnTab: true
                    }); 
                } else if( $(this).hasClass('cpf') ){
                    $(this).inputmask({
                        mask: "999.999.999-99",
                        keepStatic: true,
                        positionCaretOnTab: true
                    }); 
                } else if( $(this).hasClass('datepicker') ){
                    $(this).datepicker({
                        format: 'dd/mm/yyyy',
                        language: 'pt-BR',
                        todayHighlight: true
                    });

                    $(this).inputmask({
                        mask: "99/99/9999",
                        keepStatic: true,
                        positionCaretOnTab: true
                    }); 
                } else if( $(this).hasClass('datetimepicker') ){
                    flatpickr(this, settings.flatpickr);
                }
                //limpa o valor
                this.value = '';
                if($(this).is(":checkbox")) {
                    $(this).prop('checked', false);
                }
            }
        });

        //coloca-se no parent
        clone.appendTo( $(item).parent() );

        $('select').select2();
        $(".select2icon").select2({
            escapeMarkup: function (markup) { return markup; }
        });

        //para não dar submit
        return false;
    });

    //caso o parâmetro de ativação do botão de exclusão do item seja falso, o gatilho de execução
    //deverá ser reescrito. Isso é útil para quando houverem outras operações além de remover o
    //item, como cálculos.
    if(enableDel){
        $(document).on('click', delButton, function() {
            //verificação que impede a exclusão de quando houve apenas um item
            if($(item).length > 1){
                //após o fade, remove o item
                $(this).parent().parent().fadeOut('fast', function(){
                    $(this).remove();
                });
            }
            return false;
        });
    }
}