# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < ApplicationController
    include Cor1440Gen::Concerns::Controllers::ActividadesController

    # No confiar parametros a Internet, sólo permitir lista blanca
    def actividad_params
      params.require(:actividad).permit(
        :oficina_id, :nombre, 
        :objetivo, :proyecto, :resultado,
        :fecha, :actividad, :observaciones, 
        :usuario_id,
        :lugar,
        :actividadarea_ids => [],
        :actividadtipo_ids => [],
        :poa_ids => [],
        :proyecto_ids => [],
        :proyectofinanciero_ids => [],
        :usuario_ids => [],
        :actividad_rangoedadac_attributes => [
          :id, :rangoedadac_id, :fl, :fr, :ml, :mr, :_destroy
      ],
        :actividad_sip_anexo_attributes => [
          :id,
          :id_actividad, 
          :_destroy,
          :sip_anexo_attributes => [
            :id, :descripcion, :adjunto, :_destroy
      ]
      ]
      )
    end

  end
end
