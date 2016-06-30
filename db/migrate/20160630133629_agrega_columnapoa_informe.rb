class AgregaColumnapoaInforme < ActiveRecord::Migration
  def change
    add_column :cor1440_gen_informe, :columnapoa, :boolean
  end
end
