class AgregaCamposCasoBasicos < ActiveRecord::Migration[6.0]
  def change
    add_column :sivel2_sjr_casosjr, :numregfamilia, :string, limit: 128
    add_column :sivel2_sjr_casosjr, :fechafinaliza, :date
  end
end
