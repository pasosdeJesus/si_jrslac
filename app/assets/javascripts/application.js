// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require sip/motor
//= require cor1440_gen/motor
//= require sal7711_web/motor
//= require lazybox
//= require chosen-jquery
//= require jquery-ui/widgets/sortable
//= require jquery-ui/widgets/autocomplete
//= require_tree .

$(document).on('turbolinks:load ready page:load', function() {
  var root;
  root = typeof exports !== "undefined" && exports !== null ? 
    exports : window;	
  sip_prepara_eventos_comunes(root);
  cor1440_gen_prepara_eventos_comunes(root);
  sal7711_gen_prepara_eventos_comunes(root);

  //	formato_fecha = 'yyyy-mm-dd'
  //	if ($('meta[name=formato_fecha]') != []) {
  //		formato_fecha = $('meta[name=formato_fecha]').attr('content')
  //	}
  $('[data-behaviour~=datepicker]').datepicker({
    format: formato_fecha,
    autoclose: true,
    todayHighlight: true,
    language: 'es'	
  });

  $( "#sortable1, #sortable2" ).sortable({
    connectWith: ".connectedSortable"
  }) //.disableSelection();

  $(document).on('click', 'form[action*=informes] input[name=commit]', 
      function(e) {

        $('input[id^=informe_col]').each(function(i, d) {
          $(d).val('')
        })
        $('#sortable2 li').each(function(i, d) {
          $('#informe_col' + (i+1)).val($(d).text())
        }) 
      }
      )
  prepara_actividadpf(root)

});

const DEP_OBJETIVOPF = [
  'select[id^=proyectofinanciero_resultadopf_attributes][id$=_objetivopf_id]'
]

function actualiza_objetivos(e, objetivo) {
  sip_actualiza_cuadros_seleccion_dependientes('objetivospf', 
      '_id', '_numero', DEP_OBJETIVOPF, 'id', 'numero')
}

$(document).on('change', '#objetivospf [id$=_numero]', actualiza_objetivos)

$(document).on('cocoon:after-remove', '#objetivospf', actualiza_objetivos)

$(document).on('cocoon:after-insert', '#objetivospf', actualiza_objetivos)

$(document).on('cocoon:before-remove', '#objetivospf', function (e, objetivo) {
  return sip_intenta_eliminar_fila(objetivo, '/objetivospf/', DEP_OBJETIVOPF)
})


const DEP_RESULTADOPF = [
   'select[id^=proyectofinanciero_indicadorpf_attributes][id$=_resultadopf_id]',
   'select[id^=proyectofinanciero_actividadpf_attributes][id$=_resultadopf_id]'
]

function actualiza_resultados(e, resultado) {
  sip_actualiza_cuadros_seleccion_dependientes('resultadospf', 
      '_id', '_numero', DEP_RESULTADOPF, 'id', 'numero')
}

$(document).on('change', '#resultadospf [id$=_numero]', actualiza_resultados)

$(document).on('cocoon:after-remove', '#resultadospf', actualiza_resultados)

$(document).on('cocoon:after-insert', '#resultadospf', actualiza_resultados)

$(document).on('cocoon:before-remove', '#resultadospf', function (e, resultado) {
  return sip_intenta_eliminar_fila(resultado, '/resultadospf/', 
      DEP_RESULTADOPF
  )
})

$(document).on('change', '#resultadospf [id$=_id]', function (e, result) {
  sip_enviarautomatico_formulario($('form'), 'POST', 'json', true, 'Enviar')
})

const DEP_INDICADORPF = []

$(document).on('cocoon:before-remove', '#indicadorespf', function (e, indicador) {
  return sip_intenta_eliminar_fila(indicador, '/indicadorespf/', 
      DEP_INDICADORPF)
})

$(document).on('change', '#indicadorespf [id$=_id]', function (e, result) {
  sip_enviarautomatico_formulario($('form'), 'POST', 'json', true, 'Enviar')
})
