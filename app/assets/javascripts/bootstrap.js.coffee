jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

@llena_pf = ($this, root) ->
  sip_arregla_puntomontaje(root)
  idfecha = $this.attr('fecha_localizada')
  idpf = 'actividad_proyectofinanciero_ids'
  fecha = $this.val()
  x = $.getJSON(root.puntomontaje + 'proyectosfinancieros', {fecha: fecha})
  x.done((data) ->
    # con chosen toca:
    porelim = [] 
    yaesta = []
    $('#' + idpf).children().each( (i, e) ->
        esta = false
        $.each( data, ( j, nitem ) -> 
          vnitem = $(e).val()
          if nitem.id==vnitem
            esta = true
        )
        if !esta
          porelim.push(i)
        else
          yaesta.push(vnitem)
    )
    $.each(porelim, (i,p) -> 
      $('#'+idpf).children(i).remove()
    )
    $.each(data, (j, nitem) ->
      esta = false
      $.each(yaesta, (i, v) ->
        if v == nitem.id
          esta = true
      )
      if !esta
        $('#'+idpf).append('<option value="' + nitem.id + '">' + nitem.nombre + '</option>')
    )
    #remove()
    #$.each( data, ( i, item ) -> 
    #$('#' + idpf).append('<option value="' + 
    #    item.id + '">' + item.nombre + '</option>')
    #)
    $('#' + idpf).trigger("chosen:updated");
    #$('#' + idpf).attr('disabled', false) 
    #npf = $('#' + idpf).clone()
    #npf.empty().append(op)
  )
  x.error((m1, m2, m3) -> 
    alert(
      'Problema leyendo convenios financiados vigentes en ' + fecha + ' ' + m1 + ' ' + m2 + ' ' + m3)
    )

@llena_actividadpf = ($this, root) ->
  debugger

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



  $(document).on('change', 'select[id=actividad_][id$=proyectofinanciero_ids]', (e) ->
    llena_actividadpf($(this), root)
  )
