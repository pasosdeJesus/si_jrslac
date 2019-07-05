# encoding: UTF-8

require_dependency 'sivel2_sjr/concerns/controllers/casos_controller'

module Sivel2Sjr
  class CasosController < ApplicationController

    include Sivel2Sjr::Concerns::Controllers::CasosController

    def otros_params_casosjr
      [
        :fechafinaliza,
        :estadocaso_id,
        :numregfamilia
      ] 
    end

    def otros_params_victima
      [
        :hijos
      ]
    end
 
    def otros_params_victimasjr
      [
        :apellidomaterno,
        :nombrenooficial,
        :descripcionsenas,
        :dependientes,
        :razon
      ]
    end 

    def otros_params
      [
        factorvulnerabilidad_ids: [],
        respuestafor_attributes: [
          :id,
          valorcampo_attributes: [ 
            :valor,
            :campo_id,
            :id ] + 
          [:valor_ids => []]
        ]
      ]
    end

    def new
      @registro = @caso = Sivel2Gen::Caso.new
      new_sivel2_sjr
      redirect_to sivel2_gen.edit_caso_path(@registro) 
    end

    def asegura_camposdinamicos(caso)
      vfid = []  # ids de formularios que deben presentarse
      current_usuario.dominio_principal.formulariocaso.pestanafc.
        order(:orden).each do |p|
        if p.parcial.starts_with?('Formulario::')
          mf = Mr519Gen::Formulario.where(nombreinterno: p.parcial[12..-1])
          if mf.count == 1
            f = mf.take
            vfid << f.id
            aw = caso.respuestafor.where(formulario_id: f.id) 
            if  aw.count == 0
              rf = Mr519Gen::Respuestafor.create(
                formulario_id: f.id,
                fechaini: Date.today,
                fechacambio: Date.today)
                cr = Sivel2Gen::CasoRespuestafor.create(
                  caso_id: caso.id,
                  respuestafor_id: rf.id,
                )
            else # aw.count == 1
              r = aw.take
              cr = Sivel2Gen::CasoRespuestafor.where(
                caso_id: caso.id,
                respuestafor_id: r.id,
              ).take
            end
            Mr519Gen::ApplicationHelper::asegura_camposdinamicos(cr)
          end
        end
      end
      # Elimina sobrantes
      if vfid.count > 0
        cr = Sivel2Gen::CasoRespuestafor.
          where(caso_id: caso.id).
          joins(:respuestafor).
          where("formulario_id NOT IN (#{vfid.join(', ')})")
      else #vfid.count == 0
        cr = Sivel2Gen::CasoRespuestafor.
          where(caso_id: caso.id)
      end
      if cr.count > 0
        rb = cr.map(&:respuestafor_id)
        Cor1440Gen::CasoRespuestafor.connection.
          execute("DELETE FROM sivel2_gen_caso_respuestafor
                        WHERE caso_id=#{caso.id} 
                        AND respuestafor_id IN (#{rb.join(', ')})")
        Mr519Gen::Respuestafor.where(id: rb).destroy_all
      end
    end

  end
end
