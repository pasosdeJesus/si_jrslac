class InformeFiltropoa < ActiveRecord::Migration
  def change
      add_column :cor1440_gen_informe, :filtropoa, :integer
  end
end
