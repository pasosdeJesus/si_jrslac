class CambiaAyudasSjr < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      UPDATE sivel2_sjr_ayudasjr SET
        fechadeshabilitacion='2018-11-11' WHERE fechadeshabilitacion IS NULL;
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (20, 'TRANSPORTES', 
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (21, 'ALIMENTACIÓN', 
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (22, 'ARRIENDO',
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (23, 'SALUD',
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (24, 'TRAMITES DE DOCUMENTOS',
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (25, 'ASEO',
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (26, 'KITS HOGAR',
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (27, 'KITS BEBES Y/O NIÑOS',
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (28, 'EDUCACIÓN',
        '2018-11-11', '2018-11-11', '2018-11-11');
      INSERT INTO sivel2_sjr_ayudasjr (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (29, 'GASTOS FÚNEBRES',
        '2018-11-11', '2018-11-11', '2018-11-11');

       ---
      UPDATE sivel2_sjr_aspsicosocial SET
        fechadeshabilitacion='2018-11-11' WHERE fechadeshabilitacion IS NULL;;
     INSERT INTO sivel2_sjr_aspsicosocial (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (20, 'PRIMEROS AUXILIOS PSICOLÓGICOS',
        '2018-11-11', '2018-11-11', '2018-11-11');
     INSERT INTO sivel2_sjr_aspsicosocial (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (21, 'ACOMPAÑAMIENTO FAMILIAR',
        '2018-11-11', '2018-11-11', '2018-11-11');
     INSERT INTO sivel2_sjr_aspsicosocial (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (22, 'INTERVENCIÓN',
        '2018-11-11', '2018-11-11', '2018-11-11');
     INSERT INTO sivel2_sjr_aspsicosocial (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (23, 'SEGUIMIENTO A CASO',
        '2018-11-11', '2018-11-11', '2018-11-11');
       ---
      UPDATE sivel2_sjr_aslegal SET
        fechadeshabilitacion='2018-11-11' WHERE fechadeshabilitacion IS NULL;
     INSERT INTO sivel2_sjr_aslegal (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (20, 'ASESORÍA EN TEMAS MIGRATORIOS',
        '2018-11-11', '2018-11-11', '2018-11-11');
     INSERT INTO sivel2_sjr_aslegal (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (21, 'ASESORÍA EN ACCESO A DERECHOS',
        '2018-11-11', '2018-11-11', '2018-11-11');
     INSERT INTO sivel2_sjr_aslegal (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (22, 'INTERPOSICIÓN DE MECANISMOS',
        '2018-11-11', '2018-11-11', '2018-11-11');
     INSERT INTO sivel2_sjr_aslegal (id, nombre, 
        fechacreacion, created_at, updated_at) 
        VALUES (23, 'SEGUIMIENTO A CASOS',
        '2018-11-11', '2018-11-11', '2018-11-11');

    SQL
  end
  def down
    execute <<-SQL
      DELETE FROM sivel2_sjr_ayudasjr WHERE id>='20' AND id<'30';
      UPDATE sivel2_sjr_ayudasjr SET
        fechadeshabilitacion=NULL
        WHERE fechadeshabilitacion='2018-11-11';
      DELETE FROM sivel2_sjr_aspsicosocial WHERE id>='20' AND id<'24';
      UPDATE sivel2_sjr_aspsicosocial SET
        fechadeshabilitacion=NULL
        WHERE fechadeshabilitacion='2018-11-11';
      DELETE FROM sivel2_sjr_aslegal WHERE id>='20' AND id<'24';
      UPDATE sivel2_sjr_aslegal SET
        fechadeshabilitacion=NULL
        WHERE fechadeshabilitacion='2018-11-11';
    SQL
  end
end
