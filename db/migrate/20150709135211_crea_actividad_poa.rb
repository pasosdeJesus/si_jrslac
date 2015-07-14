class CreaActividadPoa < ActiveRecord::Migration
  def change
    create_join_table :actividad, :poa, {
      table_name: 'actividad_poa' 
    }
    add_foreign_key :actividad_poa, :cor1440_gen_actividad, 
      column: :actividad_id
    add_foreign_key :actividad_poa, :poa, column: :poa_id
  end
end
