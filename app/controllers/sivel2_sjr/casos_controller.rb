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
  end
end
