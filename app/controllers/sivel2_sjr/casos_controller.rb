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
        factorvulnerabilidad_ids: []
      ]
    end
  end
end
