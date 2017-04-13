class OrdenColumnasInformeLac < ActiveRecord::Migration[5.0]

  def up
    add_column :cor1440_gen_informe, :col10, :string, limit: 100
    execute <<-SQL
    UPDATE cor1440_gen_informe SET col10='Componente del POA' WHERE columnapoa;
    SQL
#    execute <<-SQL
#    ALTER TABLE cor1440_gen_informe ALTER col10 SET DEFAULT 'Componente del POA';
#    SQL
  end

  def down
    execute <<-SQL
    UPDATE cor1440_gen_informe SET columnapoa='t' WHERE col10='Componente del POA';
    SQL
    remove_column :cor1440_gen_informe, :col10
  end
end
