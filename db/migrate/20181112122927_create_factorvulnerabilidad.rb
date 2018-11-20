class CreateFactorvulnerabilidad < ActiveRecord::Migration[5.2]
  def up
    create_table :factorvulnerabilidad do |t|
      t.string :nombre, limit: 500, null: false
      t.string :observaciones, limit: 5000
      t.date :fechacreacion, null: false
      t.date :fechadeshabilitacion
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end
    execute <<-SQL
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(1, 'GESTANTE Y/O LACTANTE',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(2, 'PERSONA CABEZA DE FAMILIA',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(3, 'FAMILIA CON UN INTEGRANTE CON DISCAPACIDAD',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(4, 'AFRO DESCENDIENTE O INDÍGENA',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(5, 'PERSONAS LGBTI',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(6, 'FAMILIA CON UN INTEGRANTE ADULTO MAYOR',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(7, 'NNAJ NO ACOMPAÑADOS',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(8, 'VÍCTIMA DE VIOLENCIA SEXUAL',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(9, 'VÍCTIMA DE CONFLICTO ARMADO',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(10, 'SIN INGRESOS ECONÓMICOS REGULARES',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(11, 'MENORES DESESCOLARIZADOS',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(12, 'INTEGRANTES EN RIESGO DE DESNUTRICIÓN',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(13, 'INTEGRANTES CON CONSUMO DE SUSTANCIAS PSICOACTIVAS',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(14, 'SIN RESIDENCIA PERMANENTE ',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(15, 'RESIDENCIA CON NIVELES BAJO DE HABITABILIDAD',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(16, 'EN RIESGO DE VINCULACIÓN Y/O RECLUTAMIENTO POR PARTE DE UN GAO O ACTIVIDADES ILEGALES',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(17, 'INTEGRANTE CON ENFERMEDADES CATASTRÓFICAS O DE ALTO COSTO',
        '2018-11-12', '2018-11-12', '2018-11-12');
      INSERT INTO factorvulnerabilidad (id, nombre,
        fechacreacion, created_at, updated_at)
        VALUES(19, 'EN RIESGO O EN EJERCICIO DE SEXO POR SUPERVIVENCIA',
        '2018-11-12', '2018-11-12', '2018-11-12');
    SQL
  end

  def down
    drop_table :factorvulnerabilidad
  end
end
