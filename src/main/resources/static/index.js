
$(document).on('click', '#btn_cerca, .filtro', function(e){

    var consegna_gratis = $(this).attr('data-consegna_gratis');
    var descrizione = $('#in_ricerca').val();

    $.ajax({
            url: window.location.origin+'/search?' +
            ( descrizione ? 'descrizione=' + descrizione : '' ) +
            ( typeof consegna_gratis !== 'undefined' ? '&consegna_gratis='+consegna_gratis : '')
            , type: 'POST'
            , contentType: 'application/json'
            , success: function (data) {
                console.log(JSON.stringify(data));

                $('#tb_risultati').html('');

                for(idx in data['prodottoList']){

                    obj = data['prodottoList'][idx];

                    $('#tb_risultati').append(
                        '<tr>' +
                        '<td style="width: 10%;">'+obj['macro_categoria']+'</td>' +
                        '<td style="width: 10%;">'+obj['sotto_categoria']+'</td>' +
                        '<td style="width: 10%;">'+obj['nome_prodotto']+'</td>' +
                        '<td style="width: 30%;">'+obj['descrizione_analizzata']+'</td>' +
                        '<td style="width: 5%;">'+(obj['consegna_gratuita'] ? "si" : "no")+'</td>' +
                        '<td style="width: 5%;">'+obj['prezzo']+'</td>' +
                        '</tr>'
                    );
                }

                for(idx in data['aggregazioneList']) {
                    if(data['aggregazioneList'][idx]["nome"] == 'consegna'){
                        consegna_gratis_count = data['aggregazioneList'][idx]["valori"]["true"];
                        consegna_pagamento_count = data['aggregazioneList'][idx]["valori"]["false"];
                        $('#filtri').html(
                            '<button data-consegna_gratis="true" class="filtro">Consegna gratis ('+(consegna_gratis_count ? consegna_gratis_count : 0)+')</button>' +
                            '<br>' +
                            '<button data-consegna_gratis="false" class="filtro">Consegna a pagamento ('+(consegna_pagamento_count ? consegna_pagamento_count : 0)+')</button>'
                        )
                    }
                }

            }
        }
    );
});
