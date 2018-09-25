class ArreglaDetalles < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      ALTER TABLE sivel2_sjr_victimasjr ADD CONSTRAINT 
        sivel2_sjr_victimasjr_pkey
        PRIMARY KEY (id_victima);


      INSERT INTO sip_tsitio (id, nombre, fechacreacion, fechadeshabilitacion, created_at, updated_at, observaciones) VALUES (1, 'SIN INFORMACIÓN', '2001-01-01', NULL, NULL, NULL, NULL);
    SQL
  end
end
