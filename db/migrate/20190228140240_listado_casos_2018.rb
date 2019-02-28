class ListadoCasos2018 < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      INSERT INTO public.heb412_gen_plantillahcm (id, ruta, fuente, licencia, vista, nombremenu, filainicial) VALUES (17, 'Plantillas/listado_casos_2018.ods', 'LAC', '', 'Caso', 'Listado de Casos 2018', 3);

      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (51, 17, 'fecharec', 'A');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (52, 17, 'caso_id', 'B');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (53, 17, 'nusuario', 'C');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (54, 17, 'contacto', 'D');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (55, 17, 'statusmigratorio', 'BW');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (56, 17, 'victimas', 'AH');

    SQL
  end
  def down
    execute <<-SQL
      DELETE FROM heb412_gen_campoplantillahcm WHERE id>='51' AND id<='56';
      DELETE FROM heb412_gen_plantillahcm WHERE id='17';
    SQL
  end
end
