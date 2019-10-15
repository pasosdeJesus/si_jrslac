class ConvierteRespcasoLacActividad < ActiveRecord::Migration[6.0]
  def up
    Sivel2Sjr::Respuesta.all.each do |r|
      a = Cor1440Gen::Actividad.create(
        nombre: "Respuesta al caso #{r.id_caso} del #{r.fechaatencion}",
        fecha: r.fechaatencion,
        oficina_id: r.caso.casosjr.oficina_id,
        observaciones: r.observaciones,
        usuario_id: r.caso.casosjr.asesor
      )
      a.casosjr_ids = [r.id_caso]
      a.proyectofinanciero_ids = [10]
      a.actividadpf_ids = [112]

      a.save
     
      rf = Mr519Gen::Respuestafor.create(
       formulario_id: 10, # Seguimiento a caso
       fechaini: r.fechaatencion,
       fechacambio: r.fechaatencion
      )
      a.respuestafor_ids = [rf.id]
      Mr519Gen::Valorcampo.create(
        campo_id: 100,
        respuestafor_id: rf.id,
        valor: r.descamp
      )
      Mr519Gen::Valorcampo.create(
        campo_id: 101,
        respuestafor_id: rf.id,
        valor: r.compromisos
      )
      Mr519Gen::Valorcampo.create(
        campo_id: 102,
        respuestafor_id: rf.id,
        valor: r.gestionessjr
      )

      if r.ayudasjr.count > 0 || (r.detallear && r.detallear != '')
        a.actividadpf_ids += [116]  # No funcionó con a.actividadpf_ids << 116
        rf = Mr519Gen::Respuestafor.create(
          formulario_id: 11, # Asistencia humanitaria
          fechaini: r.fechaatencion,
          fechacambio: r.fechaatencion
        )
        a.respuestafor_ids += [rf.id]
        Mr519Gen::Valorcampo.create(
          campo_id: 104,
          respuestafor_id: rf.id,
          valorjson: r.ayudasjr_ids.map(&:to_s)
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 105,
          respuestafor_id: rf.id,
          valor: r.detallear
        )
      end

      if r.aspsicosocial.count > 0 || (r.detalleap && r.detalleap != '')
        a.actividadpf_ids += [117]
        rf = Mr519Gen::Respuestafor.create(
          formulario_id: 12, # Asistencia psicosocial
          fechaini: r.fechaatencion,
          fechacambio: r.fechaatencion
        )
        a.respuestafor_ids += [rf.id]
        Mr519Gen::Valorcampo.create(
          campo_id: 106,
          respuestafor_id: rf.id,
          valorjson: r.aspsicosocial_ids.map(&:to_s)
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 107,
          respuestafor_id: rf.id,
          valor: r.detalleap
        )
      end

      if r.aslegal.count > 0 || (r.detalleal && r.detalleal != '')
        a.actividadpf_ids += [118]
        rf = Mr519Gen::Respuestafor.create(
          formulario_id: 13, # Asistencia legal 
          fechaini: r.fechaatencion,
          fechacambio: r.fechaatencion
        )
        a.respuestafor_ids += [rf.id]
        Mr519Gen::Valorcampo.create(
          campo_id: 108,
          respuestafor_id: rf.id,
          valorjson: r.aslegal_ids.map(&:to_s)
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 109,
          respuestafor_id: rf.id,
          valor: r.detalleal
        )
      end

      a.save
    end
  end

  def down
    execute <<-SQL
      DELETE FROM mr519_gen_valorcampo WHERE 
        respuestafor_id IN (SELECT id FROM mr519_gen_respuestafor
        WHERE formulario_id IN (10, 11, 12));

      DELETE FROM cor1440_gen_actividad_respuestafor WHERE 
        respuestafor_id IN (SELECT id FROM mr519_gen_respuestafor
        WHERE formulario_id IN (10, 11, 12));

      DELETE FROM mr519_gen_respuestafor WHERE 
        formulario_id IN (10, 11, 12);

      DELETE FROM cor1440_gen_actividad_proyectofinanciero WHERE 
        actividad_id IN (SELECT id FROM cor1440_gen_actividad
          WHERE nombre LIKE 'Respuesta al caso%');

      DELETE FROM cor1440_gen_actividad_actividadpf WHERE 
        actividad_id IN (SELECT id FROM cor1440_gen_actividad
          WHERE nombre LIKE 'Respuesta al caso%');

      DELETE FROM sivel2_sjr_actividad_casosjr WHERE 
        actividad_id IN (SELECT id FROM cor1440_gen_actividad
          WHERE nombre LIKE 'Respuesta al caso%');

      DELETE FROM cor1440_gen_actividad WHERE nombre 
        LIKE 'Respuesta al caso%';
    SQL
  end
end
