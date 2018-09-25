# Migración para integrar sivel2_sjr 
class AcpasSjr < ActiveRecord::Migration[5.2]
  def up
    rename_table :regimensalud, :sivel2_sjr_regimensalud
  end
  def down
    rename_table :sivel2_sjr_regimensalud, :regimensalud
  end
end
