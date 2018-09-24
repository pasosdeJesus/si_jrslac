class ContextosInforme < ActiveRecord::Migration[4.2]
  def change
    add_column :cor1440_gen_informe, :contextointerno, :string, limit: 5000
    add_column :cor1440_gen_informe, :contextoexterno, :string, limit: 5000
  end
end
