class OrdenColumnasInforme < ActiveRecord::Migration[5.0]
  def change
    add_column :cor1440_gen_informe, :col1, :string, limit: 100
    add_column :cor1440_gen_informe, :col2, :string, limit: 100
    add_column :cor1440_gen_informe, :col3, :string, limit: 100
    add_column :cor1440_gen_informe, :col4, :string, limit: 100
    add_column :cor1440_gen_informe, :col5, :string, limit: 100
    add_column :cor1440_gen_informe, :col6, :string, limit: 100
    add_column :cor1440_gen_informe, :col7, :string, limit: 100
    add_column :cor1440_gen_informe, :col8, :string, limit: 100
    add_column :cor1440_gen_informe, :col9, :string, limit: 100
    add_column :cor1440_gen_informe, :col10, :string, limit: 100
  end
end
