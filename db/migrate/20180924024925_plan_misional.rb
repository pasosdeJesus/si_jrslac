class PlanMisional < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      INSERT INTO cor1440_gen_proyectofinanciero (id, nombre, observaciones, 
        fechainicio, fechacierre, responsable_id, fechacreacion, 
        fechadeshabilitacion, created_at, updated_at, compromisos, monto) 
      VALUES (10, 'PLAN MISIONAL JRS-LAC', 'Para homologar tipos de actividad anterior a 2018 como actividades de este convenio', 
        '2014-10-01', NULL, NULL, '2018-05-31', 
        NULL, '2018-05-31', '2018-05-31', 'Acompañar, servir y defender a la población en situación de refugio y desplazamiento', 1);

      INSERT INTO cor1440_gen_objetivopf (id, proyectofinanciero_id, numero, 
        objetivo) VALUES 
        (15, 10, 'OE1', 
        'Acompañar, servir y defender a la población en situación de refugio y desplazamiento');

      INSERT INTO cor1440_gen_resultadopf (id, proyectofinanciero_id, 
        objetivopf_id, numero, resultado) VALUES 
        (15, 10, 15, 'R1', 
        'Acompañar, servir y defender a la población en situación de refugio y desplazamiento');


      INSERT INTO cor1440_gen_actividadpf (id, proyectofinanciero_id, 
        nombrecorto, titulo, descripcion, resultadopf_id, actividadtipo_id) 
        (SELECT id+100, 10, 'AM' || CAST(id AS VARCHAR), nombre, '', 15, id 
          FROM cor1440_gen_actividadtipo);

      SELECT pg_catalog.setval('cor1440_gen_actividadpf_id_seq', max(id)+1, 
        true) FROM cor1440_gen_actividadpf;
    SQL
  end
  
  def down
    execute <<-SQL
      DELETE FROM cor1440_gen_actividadpf WHERE id in (SELECT id+100
        FROM cor1440_gen_actividadtipo WHERE id <'300');
      DELETE FROM cor1440_gen_resultadopf WHERE id=15;
      DELETE FROM cor1440_gen_objetivopf WHERE id=15;
      DELETE FROM cor1440_gen_proyectofinanciero WHERE id=10;
    SQL
  end
end
