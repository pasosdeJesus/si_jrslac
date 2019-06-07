# encoding: UTF-8

class CreateEstadocaso < ActiveRecord::Migration[6.0]
  def up
    create_table :estadocaso do |t|
      t.string :nombre, limit: 500, null: false
      t.string :observaciones, limit: 5000
      t.integer :dominio_id
      t.date :fechacreacion, null: false
      t.date :fechadeshabilitacion
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end
    add_foreign_key :estadocaso, :sipd_dominio, column: :dominio_id
    
    execute <<-SQL
      INSERT INTO estadocaso (id, nombre, observaciones, dominio_id, fechacreacion,
        fechadeshabilitacion, created_at, updated_at)
        VALUES (1, 'Solicitud inicial', '', 2, '2019-06-07', 
        NULL, '2019-06-07', '2019-06-07');
      INSERT INTO estadocaso (id, nombre, observaciones, dominio_id, fechacreacion,
        fechadeshabilitacion, created_at, updated_at)
        VALUES (2, 'Entrevista de elegibilidad', '', 2, '2019-06-07', 
        NULL, '2019-06-07', '2019-06-07');
      INSERT INTO estadocaso (id, nombre, observaciones, dominio_id, fechacreacion,
        fechadeshabilitacion, created_at, updated_at)
        VALUES (3, 'Abandono', '', 2, '2019-06-07', 
        NULL, '2019-06-07', '2019-06-07');
      INSERT INTO estadocaso (id, nombre, observaciones, dominio_id, fechacreacion,
        fechadeshabilitacion, created_at, updated_at)
        VALUES (4, 'Desistido', '', 2, '2019-06-07', 
        NULL, '2019-06-07', '2019-06-07');
      INSERT INTO estadocaso (id, nombre, observaciones, dominio_id, fechacreacion,
        fechadeshabilitacion, created_at, updated_at)
        VALUES (5, 'Reconocido', '', 2, '2019-06-07', 
        NULL, '2019-06-07', '2019-06-07');
      INSERT INTO estadocaso (id, nombre, observaciones, dominio_id, fechacreacion,
        fechadeshabilitacion, created_at, updated_at)
        VALUES (6, 'Protección complementaria', '', 2, '2019-06-07', 
        NULL, '2019-06-07', '2019-06-07');
      INSERT INTO estadocaso (id, nombre, observaciones, dominio_id, fechacreacion,
        fechadeshabilitacion, created_at, updated_at)
        VALUES (7, 'Negado', '', 2, '2019-06-07', 
        NULL, '2019-06-07', '2019-06-07');

      SELECT setval( 'public.estadocaso_id_seq', 100) ;
    SQL
  end

  def down
    drop_table :estadocaso
  end
end
