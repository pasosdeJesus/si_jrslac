# encoding: utf-8

class CambiaEstatusMigratorio < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      UPDATE sivel2_sjr_statusmigratorio 
        SET fechadeshabilitacion='2018-11-12' 
        WHERE fechadeshabilitacion IS NULL AND nombre<>'REFUGIADO';
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (20, 'IRREGULAR',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (21, 'PNPI',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (22, 'PASAPORTE CON PIP',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (23, 'VISA (V)',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (24, 'VISA (M)',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (25, 'VISA (R)',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (26, 'VISA (B)',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (27, 'PEP',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (28, 'PEP-RAMV',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO sivel2_sjr_statusmigratorio (id, nombre, 
        fechacreacion, created_at, updated_at)
        VALUES (29, 'SOLICITANTE',
        '2018-11-12', '2018-11-12', '2018-11-12');
    SQL
  end
  def down
    execute <<-SQL
      UPDATE sivel2_sjr_statusmigratorio 
        SET fechadeshabilitacion=NULL
        WHERE fechadeshabilitacion='2018-11-12';
      DELETE FROM sivel2_sjr_statusmigratorio WHERE id>='20' AND id<'30';
    SQL
  end
end
