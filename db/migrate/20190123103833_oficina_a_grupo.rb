class OficinaAGrupo < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      INSERT INTO sip_grupo (id, nombre, observaciones, fechacreacion,
        fechadeshabilitacion, created_at, updated_at) 
        (SELECT id, nombre, observaciones, fechacreacion, fechadeshabilitacion,
        created_at, updated_at FROM sip_oficina WHERE id<>1);
      INSERT INTO sipd_dominio_grupo (dominio_id, grupo_id) 
        (SELECT dominio_id, id FROM sip_oficina WHERE id<>1);
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
