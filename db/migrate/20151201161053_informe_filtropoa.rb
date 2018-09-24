class InformeFiltropoa < ActiveRecord::Migration[4.2]
  def change
      add_column :cor1440_gen_informe, :filtropoa, :integer
  end
end
