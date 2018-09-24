class AgregaColumnapoaInforme < ActiveRecord::Migration[4.2]
  def change
    add_column :cor1440_gen_informe, :columnapoa, :boolean
  end
end
