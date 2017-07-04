jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

# Remplaza las opciones de un cuadro de seleccion por unas nuevas
# @idsel es identificación del select
# @nuevasop Son las nuevas opciones
# @usachosne Es verdadero si y solo si el cuadro de selección usa chosen
# @cid campo id en cada elemento de @nuevasop
# @cnombre campo nombre en cada elemento de @nuevasop
@remplaza_opciones_select = (idsel, nuevasop, usachosen = false, cid = 'id',
  cnombre = 'nombre') ->
  porelim = [] 
  yaesta = []
  $('#' + idsel).children().each( (i, e) ->
    esta = false
    vac = $(e).val()
    $.each( nuevasop, ( j, nelem ) -> 
      if nelem[cid] == vac 
        esta = true
    )
    if !esta
      porelim.push(i)
    else
      yaesta.push(vac)
  )
  $.each(porelim, (i,p) -> 
    $('#'+idsel).children(i).remove()
  )
  $.each(nuevasop, (j, nelem) ->
    esta = false
    $.each(yaesta, (i, v) ->
      if v == nelem[cid]
        esta = true
    )
    if !esta
      $('#'+idsel).append(
        '<option value="' + nelem[cid] + '">' + nelem[cnombre] + '</option>')
  )
  if usachosen
    $('#' + idsel).trigger("chosen:updated");

@llena_pf = ($this, root) ->
  sip_arregla_puntomontaje(root)
  idpf = 'actividad_proyectofinanciero_ids'
  fecha = $this.val()
  x = $.getJSON(root.puntomontaje + 'proyectosfinancieros', {fecha: fecha})
  x.done((data) ->
    remplaza_opciones_select(idpf, data, true)
  )
  x.error((m1, m2, m3) -> 
    alert(
      'Problema leyendo convenios financiados en '+fecha+' '+m1+' '+m2+' '+m3)
    )

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
  $(document).on('change', 'select[id^=actividad_][id$=fecha_localizada]', (e) ->
    llena_pf($(this), root)
  )
  $('#actividad_fecha_localizada').datepicker({
    format: root.formato_fecha,
    autoclose: true,
    todayHighlight: true,
    language: 'es'
  }).on('changeDate', (ev) ->
    llena_pf($(this), root)
  )

  $("#actividad_proyectofinanciero_ids").chosen().change( (e) ->
    llena_actividadpf($(this), root)
  )

