class CreaVistaUltimaatencion < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
       CREATE OR REPLACE VIEW sivel2_sjr_ultimaatencion AS (
       SELECT respuesta.id_caso,
        respuesta.id,
      respuesta.fechaatencion,
      respuesta.detallemotivo,
      respuesta.detalleal,
      respuesta.detallear,
      CASE
         WHEN contacto.anionac IS NULL THEN NULL::integer
           WHEN contacto.mesnac IS NULL OR contacto.dianac IS NULL THEN (date_part('year'::text, respuesta.fechaatencion) - contacto.anionac::double precision)::integer
             WHEN contacto.mesnac::double precision < date_part('month'::text, respuesta.fechaatencion) THEN (date_part('year'::text, respuesta.fechaatencion) -
              contacto.anionac::double precision)::integer
              WHEN contacto.mesnac::double precision > date_part('month'::text, respuesta.fechaatencion) THEN (date_part('year'::text, respuesta.fechaatencion) -
               contacto.anionac::double precision - 1::double precision)::integer
               WHEN contacto.dianac::double precision > date_part('day'::text, respuesta.fechaatencion) THEN (date_part('year'::text, respuesta.fechaatencion) - contacto.anionac::double precision - 1::double precision)::integer
         ELSE (date_part('year'::text, respuesta.fechaatencion) - contacto.anionac::double precision)::integer                                              
            END AS contacto_edad
            FROM sivel2_sjr_respuesta respuesta
            JOIN sivel2_sjr_casosjr casosjr ON respuesta.id_caso = casosjr.id_caso
            JOIN sip_persona contacto ON contacto.id = casosjr.contacto_id
            WHERE ((respuesta.id_caso, respuesta.fechaatencion) IN ( SELECT sivel2_sjr_respuesta.id_caso,                                                                
              max(sivel2_sjr_respuesta.fechaatencion) AS max
              FROM sivel2_sjr_respuesta
              GROUP BY sivel2_sjr_respuesta.id_caso))
           );
    SQL
  end
  def down
    execute <<-SQL
      DROP VIEW sivel2_gen_ultimaatencion;
    SQL
  end
end
