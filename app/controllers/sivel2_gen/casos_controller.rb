# encoding: UTF-8

require 'sivel2_gen/concerns/controllers/casos_controller'

module Sivel2Gen
  class CasosController < Heb412Gen::ModelosController 

    include Sivel2Gen::Concerns::Controllers::CasosController


    # Busca valor para el campo en el contexto del diccionario que
    # incluye información del caso
    def self.valor_campo_compuesto_dic(diccionario, campo)
      if !nombrecampo.to_s.include?('.')
        return "Campo desconocido #{campo}"
      end
      # Suponemos que es caracterización del contacto
      cid = diccionario['caso_id'].to_i
      if Sivel2Sjr::Casosjr.where(id_caso: cid).count == 0
        return "No se encontró caso #{cid}"
      end
      cont = Sivel2Sjr::Casosjr.find(cid).contacto
      if cont.nil? 
        return "Caso #{cid} sin contacto"
      end
      Sip::PersonasController.valor_campo_compuesto(cont, campo)
      #        cont.caracterizacionpersona.each do |car| 
      #          if car.respuestafor && car.respuestafor.formulario &&
      #            car.respuestafor.formulario.nombreinterno == nform
      #            f = car.respuestafor.formulario
      #            cam = f.campo.where(nombreinterno: ncampo)
      #            if cam.count == 0
      #              return "No hay campo #{ncampo} en formulario #{f.nombreinterno}"
      #            elsif cam.count > 1
      #              return "Varios campos del formulario #{f.nombreinterno} " +
      #                "tienen nombre interno #{ncampo}"
      #            end
      #            cam = cam.take
      #            vc = car.respuestafor.valorcampo.where(campo_id: cam.id).take
      #            byebug
      #            return vc.presenta_valor
      #          end
    end

  end
end
