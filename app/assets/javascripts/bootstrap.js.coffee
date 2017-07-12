jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

@llena_actividadpf = ($this, root) ->
  sip_arregla_puntomontaje(root)
  idacpf = 'actividad_actividadpf_ids'
  pfl = $this.val()
  x = $.getJSON(root.puntomontaje + 'actividadespf', {pfl: pfl})
  x.done((data) ->
    remplaza_opciones_select(idacpf, data, true)
  )
  x.error((m1, m2, m3) -> 
    alert(
      'Problema leyendo actividades de convenio '+pf+' '+m1+' '+m2+' '+m3)
    )


@prepara_actividadpf = (root) ->
  sip_arregla_puntomontaje(root)
  #$(document).on('change', 'select[id^=actividad_][id$=fecha_localizada]', (e) ->
  #  cor1440_gen_llena_pf($(this), root)
  #)

  $("#actividad_proyectofinanciero_ids").chosen().change( (e) ->
    llena_actividadpf($(this), root)
  )

