class EmhaHrit < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      INSERT INTO public.heb412_gen_plantillahcm (id, ruta, fuente, licencia, vista, nombremenu, filainicial) VALUES (7, 'Plantillas/HRIT_EMAH.ods', '', '', 'Caso', 'Plantilla HRIT_EMAH', 9);


      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (701, 1, 'ultimaatencion_mes', 'A');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (702, 1, 'ultimaatencion_fecha', 'B');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (703, 1, 'contacto_nombres', 'C');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (704, 1, 'contacto_apellidos', 'D');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (705, 1, 'contacto_identificacion', 'E');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (706, 1, 'contacto_genero', 'F');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (708, 1, 'contacto_etnia', 'H');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (709, 1, 'beneficiarios_0_5', 'I');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (770, 1, 'beneficiarios_6_12', 'J');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (771, 1, 'beneficiarios_13_17', 'K');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (772, 1, 'beneficiarios_18_26', 'L');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (773, 1, 'beneficiarios_27_59', 'M');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (774, 1, 'beneficiarios_60_', 'N');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (775, 1, 'beneficiarias_0_5', 'O');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (776, 1, 'beneficiarias_6_12', 'P');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (777, 1, 'beneficiarias_13_17', 'Q');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (778, 1, 'beneficiarias_18_26', 'R');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (779, 1, 'beneficiarias_27_59', 'S');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (720, 1, 'beneficiarias_60_', 'T');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (722, 1, 'ultimaatencion_as_humanitaria', 'V');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (723, 1, 'ultimaatencion_as_juridica', 'W');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (724, 1, 'ultimaatencion_otros_ser_as', 'X');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (725, 1, 'ultimaatencion_descripcion_at', 'Y');
      INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (726, 1, 'oficina', 'Z');
      
      SELECT pg_catalog.setval('heb412_gen_campoplantillahcm_id_seq', MAX(id)) FROM heb412_gen_campoplantillahcm;
    SQL
  end
end
