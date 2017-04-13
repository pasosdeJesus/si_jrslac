class OrdenColumnasInformeLac < ActiveRecord::Migration[5.0]

  def up
    add_column :cor1440_gen_informe, :col10, :string, limit: 100
    execute <<-SQL
    UPDATE cor1440_gen_informe SET col10='Componente del POA' WHERE columnapoa;
    SQL
    execute <<-SQL
    ALTER TABLE cor1440_gen_informe ALTER col1 SET DEFAULT 'Componente del POA';
    ALTER TABLE cor1440_gen_informe ALTER col2 SET DEFAULT 'Nombre';
    ALTER TABLE cor1440_gen_informe ALTER col3 SET DEFAULT 'Tipo de Actividad';
    ALTER TABLE cor1440_gen_informe ALTER col4 SET DEFAULT 'Resultado';
    ALTER TABLE cor1440_gen_informe ALTER col5 SET DEFAULT 'Observaciones';
    ALTER TABLE cor1440_gen_informe ALTER col6 DROP DEFAULT;
    ALTER TABLE cor1440_gen_informe ALTER col7 DROP DEFAULT;
    ALTER TABLE cor1440_gen_informe ALTER col8 DROP DEFAULT;
    ALTER TABLE cor1440_gen_informe ALTER col9 DROP DEFAULT;
    ALTER TABLE cor1440_gen_informe ALTER col10 DROP DEFAULT;
    SQL
  end

  def down
    execute <<-SQL
    UPDATE cor1440_gen_informe SET columnapoa='t' WHERE col10='Componente del POA';
    SQL
    remove_column :cor1440_gen_informe, :col10
  end
end
