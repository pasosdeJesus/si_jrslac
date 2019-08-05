class AgregaSeguimientosCaso < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      -- actividadtipo 12 es SEGUIMIENTO A CASO que ya está en el proyecto

      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('10', 'SEGUIMIENTO A CASO', 'seguimiento_a_caso') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('100', 'Situación encontrada', 'situacion_encontrada',
        '2', 10, 1);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('101', 'Compromisos de la persona', 'compromisos_de_la_persona',
        '2', 10, 2);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('102', 'Compromisos del SJR', 'compromisos_del_sjr',
        '2', 10, 3);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('103', 'Observaciones', 'observaciones',
        '2', 10, 4);
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('12', '10');

      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (16, 'ASISTENCIA HUMANITARIA', 
        '2019-08-05', '2019-08-05', '2019-08-05');
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('11', 'ASISTENCIA HUMANITARIA', 'asistencia_humanitaria') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, tablabasica, formulario_id, fila) VALUES
        ('104', 'Asistencia humanitaria', 'asistencia_humanitaria',
        '14', 'ayudassjr', 11, 1);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila) VALUES
        ('105', 'Detalle de asistencia humanitaria', 
          'detalle_asistencia_humanitaria', '1', 11, 2);
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('16', '11');
      INSERT INTO cor1440_gen_actividadpf
        (id, proyectofinanciero_id, nombrecorto, titulo, resultadopf_id, actividadtipo_id)
        VALUES (116, 10, 'AM16', 'ASISTENCIA HUMANITARIA', 15, 16);    

      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (17, 'ASISTENCIA PSICOSOCIAL', 
        '2019-08-05', '2019-08-05', '2019-08-05');
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('12', 'ASISTENCIA PSICOSOCIAL', 'asistencia_psicosocial') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, tablabasica, formulario_id, fila) VALUES
        ('106', 'Asistencia Psicosocial', 'asistencia_psicosocial',
          '14', 'aspsicosociales', 12, 1);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila) VALUES
        ('107', 'Detalle de asistencia psicosocial', 
          'detalle_asistencia_psicosocial', '1', 12, 2);
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('17', '12');
      INSERT INTO cor1440_gen_actividadpf
        (id, proyectofinanciero_id, nombrecorto, titulo, resultadopf_id, actividadtipo_id)
        VALUES (117, 10, 'AM17', 'ASISTENCIA PSICOSOCIAL', 15, 17);    

      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (18, 'ASISTENCIA LEGAL', 
        '2019-08-05', '2019-08-05', '2019-08-05');
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('13', 'ASISTENCIA LEGAL', 'asistencia_legal') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, tablabasica, formulario_id, fila) VALUES
        ('108', 'Asistencia Legal', 'asistencia_legal',
          '14', 'aslegales', 13, 1);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('109', 'Detalle de asistencia legal', 
          'detalle_asistencia_legal', '1', 13, 2);
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('18', '13');
      INSERT INTO cor1440_gen_actividadpf
        (id, proyectofinanciero_id, nombrecorto, titulo, resultadopf_id, actividadtipo_id)
        VALUES (118, 10, 'AM18', 'ASISTENCIA LEGAL', 15, 18);    

    SQL
  end
  def down
    execute <<-SQL
      DELETE FROM cor1440_gen_actividadtipo_formulario 
        WHERE actividadtipo_id='12' AND formulario_id='10';
      DELETE FROM mr519_gen_campo
        WHERE id>='100' and id<='103';
      DELETE FROM mr519_gen_formulario WHERE id='10';
      
      DELETE FROM cor1440_gen_actividadpf WHERE id='116';
      DELETE FROM cor1440_gen_actividadtipo_formulario 
        WHERE actividadtipo_id='16' AND formulario_id='11';
      DELETE FROM mr519_gen_campo
        WHERE id>='104' and id<='105';
      DELETE FROM mr519_gen_formulario WHERE id='11';
      DELETE FROM cor1440_gen_actividadtipo WHERE id='16';

      DELETE FROM cor1440_gen_actividadpf WHERE id='117';
      DELETE FROM cor1440_gen_actividadtipo_formulario 
        WHERE actividadtipo_id='17' AND formulario_id='12';
      DELETE FROM mr519_gen_campo
        WHERE id>='106' and id<='107';
      DELETE FROM mr519_gen_formulario WHERE id='12';
      DELETE FROM cor1440_gen_actividadtipo WHERE id='17';

      DELETE FROM cor1440_gen_actividadpf WHERE id='118';
      DELETE FROM cor1440_gen_actividadtipo_formulario 
        WHERE actividadtipo_id='18' AND formulario_id='13';
      DELETE FROM mr519_gen_campo
        WHERE id>='108' and id<='109';
      DELETE FROM mr519_gen_formulario WHERE id='13';
      DELETE FROM cor1440_gen_actividadtipo WHERE id='18';
    SQL
  end
end
