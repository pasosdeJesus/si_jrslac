class MuevePlantillas < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      UPDATE heb412_gen_plantillahcr SET ruta='Plantillas/reporte_una_actividad.ods' WHERE id='5';
      UPDATE heb412_gen_plantillahcr SET ruta='Plantillas/reporte_usuario.ods' WHERE id='10';
      UPDATE heb412_gen_plantilladoc SET ruta='Plantillas/reporte_actividad.odt' WHERE id='5';
      UPDATE heb412_gen_plantilladoc SET ruta='Plantillas/reporte_usuario.odt' WHERE id='10';
    SQL
  end
  def down
  end
end
