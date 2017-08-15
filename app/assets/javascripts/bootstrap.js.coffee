jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

@prepara_actividadpf = (root) ->
  sip_arregla_puntomontaje(root)
  #$(document).on('change', 'select[id^=actividad_][id$=fecha_localizada]', (e) ->
  #  cor1440_gen_llena_pf($(this), root)
  #)

  $("#actividad_proyectofinanciero_ids").chosen().change( (e) ->
    sip_llena_select_con_AJAX($(this), 'actividad_actividadpf_ids', 'actividadespf', 'pfl', 'con Actividades de convenio', root)
  )

