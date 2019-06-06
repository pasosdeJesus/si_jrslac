class Formulariocasoinicial < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      SELECT pg_catalog.setval('formulariocaso_id_seq', 100, true);
      SELECT pg_catalog.setval('pestanafc_id_seq', 100, true);

      INSERT INTO formulariocaso(id, dominio_id) VALUES (1, 2);
      INSERT INTO pestanafc(id, formulariocaso_id, orden, titulo, parcial) 
        VALUES (1, 1, 1, 'Datos Básicos', 'basicos');
      INSERT INTO pestanafc(id, formulariocaso_id, orden, titulo, parcial) 
        VALUES (2, 1, 2, 'Contacto', 'contacto');
      INSERT INTO pestanafc(id, formulariocaso_id, orden, titulo, parcial) 
        VALUES (3, 1, 3, 'Núcleo Familiar', 'victimas');
      INSERT INTO pestanafc(id, formulariocaso_id, orden, titulo, parcial) 
        VALUES (4, 1, 4, 'Refugio', 'refugio');
      INSERT INTO pestanafc(id, formulariocaso_id, orden, titulo, parcial) 
        VALUES (5, 1, 5, 'Anexos', 'sivel2_gen/casos/anexos');
      INSERT INTO pestanafc(id, formulariocaso_id, orden, titulo, parcial) 
        VALUES (6, 1, 6, 'Etiquetas', 'sivel2_gen/casos/etiquetas');
    SQL
  end
  def down
    execute <<-SQL
      DELETE FROM formulariocaso WHERE id=1;
    SQL

  end
end
