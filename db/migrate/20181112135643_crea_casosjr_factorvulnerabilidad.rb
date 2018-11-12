class CreaCasosjrFactorvulnerabilidad < ActiveRecord::Migration[5.2]
  def change
    create_join_table :sivel2_gen_caso, :factorvulnerabilidad, {
      table_name: 'caso_factorvulnerabilidad'
    }
    rename_column :caso_factorvulnerabilidad, :sivel2_gen_caso_id, 
      :caso_id
    add_foreign_key :caso_factorvulnerabilidad,
      :sivel2_gen_caso, column: :caso_id#, primary_key: :id_caso
    add_foreign_key :caso_factorvulnerabilidad,
      :factorvulnerabilidad, column: :factorvulnerabilidad_id
  end
end
