# encoding: UTF-8

require_dependency 'sivel2_sjr/concerns/controllers/casos_controller'

module Sivel2Sjr
  class CasosController < Heb412Gen::ModelosController

    include Sivel2Sjr::Concerns::Controllers::CasosController

    def otros_params_victima
      [:genero]
    end

    def otros_params
      [
        factorvulnerabilidad_ids: []
      ]
    end
   
   def otros_params_persona
     [
        proyectofinanciero_ids: [],
        "caracterizacionpersona_attributes" =>
        [ :id,
          "respuestafor_attributes" => [
            :id,
            "valorcampo_attributes" => [
              :valor,
              :campo_id,
              :id 
            ] + [:valor_ids => []],
        ] ]
     ] 
    end

    def self.valor_campo_compuesto(registro, campo)
      cs = Sivel2Sjr::Casosjr.find(registro.caso_id)
      Sip::PersonasController.valor_campo_compuesto(cs.contacto, campo)
    end

    def self.asegura_camposdinamicos(caso, current_usuario_id)
      p = caso.casosjr.contacto
      Sip::PersonasController.asegura_camposdinamicos(p, current_usuario_id)
    end

    def importa_dato(datosent, datossal, menserror, registro = nil, opciones = {})
      importa_dato_gen(datosent, datossal, menserror, registro, opciones)
      # byebug
      # Aqui si el parametro incluia crear caso, crearlo
    end

  end
end
