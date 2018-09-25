class ArreglaDetalles2 < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      ALTER SEQUENCE IF EXISTS actividadoficio_seq 
        RENAME TO sivel2_gen_actividadoficio_id_seq;
      ALTER SEQUENCE IF EXISTS escolaridad_seq 
        RENAME TO sivel2_gen_escolaridad_id_seq;
      ALTER SEQUENCE IF EXISTS estadocivil_seq 
        RENAME TO sivel2_gen_estadocivil_id_seq;
      ALTER SEQUENCE IF EXISTS maternidad_seq 
        RENAME TO sivel2_gen_maternidad_id_seq;
    SQL
  end
end
