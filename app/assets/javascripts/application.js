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
//= require heb412_gen/motor
//= require mr519_gen/motor
//= require sal7711_web/motor
//= require sivel2_gen/motor
//= require sivel2_sjr/motor
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
  heb412_gen_prepara_eventos_comunes(root);
  mr519_gen_prepara_eventos_comunes(root);
  sivel2_gen_prepara_eventos_comunes(root,'antecedentes/causas');
  sivel2_sjr_prepara_eventos_comunes(root);
  cor1440_gen_prepara_eventos_comunes(root);
  sal7711_gen_prepara_eventos_comunes(root);
  sivel2_sjr_prepara_eventos_unicos(root);

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

});

