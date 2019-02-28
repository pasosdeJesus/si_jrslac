class AgregaObjetioGeneralProyectofinanciero < ActiveRecord::Migration[5.2]
  def change
    add_column :cor1440_gen_proyectofinanciero, :objetivogeneral, :string, 
      limit: 5000
  end
end
