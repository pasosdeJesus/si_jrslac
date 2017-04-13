class OrdenColumnasInforme < ActiveRecord::Migration[5.0]

  def up
    add_column :cor1440_gen_informe, :col1, :string, limit: 100
    add_column :cor1440_gen_informe, :col2, :string, limit: 100
    add_column :cor1440_gen_informe, :col3, :string, limit: 100
    add_column :cor1440_gen_informe, :col4, :string, limit: 100
    add_column :cor1440_gen_informe, :col5, :string, limit: 100
    add_column :cor1440_gen_informe, :col6, :string, limit: 100
    add_column :cor1440_gen_informe, :col7, :string, limit: 100
    add_column :cor1440_gen_informe, :col8, :string, limit: 100
    add_column :cor1440_gen_informe, :col9, :string, limit: 100
    execute <<-SQL
    UPDATE cor1440_gen_informe SET col1='Fecha' WHERE columnafecha;
    UPDATE cor1440_gen_informe SET col2='Responsable' WHERE columnaresponsable;
    UPDATE cor1440_gen_informe SET col3='Nombre' WHERE columnanombre;
    UPDATE cor1440_gen_informe SET col4='Tipo de Actividad' WHERE columnatipo;
    UPDATE cor1440_gen_informe SET col5='Objetivo' WHERE columnaobjetivo;
    UPDATE cor1440_gen_informe SET col6='Área' WHERE columnaobjetivo;
    UPDATE cor1440_gen_informe SET col7='Población' WHERE columnapoblacion;
    SQL
#    execute <<-SQL
#    ALTER TABLE cor1440_gen_informe ALTER col1 SET DEFAULT 'Fecha';
#    ALTER TABLE cor1440_gen_informe ALTER col2 SET DEFAULT 'Responsable';
#    ALTER TABLE cor1440_gen_informe ALTER col3 SET DEFAULT 'Nombre';
#    ALTER TABLE cor1440_gen_informe ALTER col4 SET DEFAULT 'Tipo de Actividad';
#    ALTER TABLE cor1440_gen_informe ALTER col5 SET DEFAULT 'Objetivo';
#    ALTER TABLE cor1440_gen_informe ALTER col6 SET DEFAULT 'Área';
#    ALTER TABLE cor1440_gen_informe ALTER col7 SET DEFAULT 'Población';
#    ALTER TABLE cor1440_gen_informe ALTER col8 SET DEFAULT 'Resultado';
#    ALTER TABLE cor1440_gen_informe ALTER col9 SET DEFAULT 'Observaciones';
#    SQL
  end

  def down
    execute <<-SQL
    UPDATE cor1440_gen_informe SET columnafecha='t' WHERE col1='Fecha';
    UPDATE cor1440_gen_informe SET columnaresponsable='t' WHERE col2='Responsable';
    UPDATE cor1440_gen_informe SET columnanombre='t' WHERE col3='Nombre';
    UPDATE cor1440_gen_informe SET columnatipo='t' WHERE col4='Tipo de Actividad';
    UPDATE cor1440_gen_informe SET columnaobjetivo='t' WHERE col5='Objetivo';
    UPDATE cor1440_gen_informe SET columnaobjetivo='t' WHERE col6='Área';
    UPDATE cor1440_gen_informe SET columnapoblacion='t' WHERE col7='Población';
    SQL
    remove_column :cor1440_gen_informe, :col1
    remove_column :cor1440_gen_informe, :col2
    remove_column :cor1440_gen_informe, :col3
    remove_column :cor1440_gen_informe, :col4
    remove_column :cor1440_gen_informe, :col5
    remove_column :cor1440_gen_informe, :col6
    remove_column :cor1440_gen_informe, :col7
    remove_column :cor1440_gen_informe, :col8
    remove_column :cor1440_gen_informe, :col9
  end
end
