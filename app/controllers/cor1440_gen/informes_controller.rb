# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/informes_controller"

module Cor1440Gen
  class InformesController < ApplicationController
    include Cor1440Gen::Concerns::Controllers::InformesController
   
    def filtra_actividades
      return Cor1440Gen::ActividadesController.filtra({
        fechaini: @informe.filtrofechaini,
        fechafin: @informe.filtrofechafin,
        busproyecto: @informe.filtroproyecto,
        busarea: @informe.filtroactividadarea,
        busproyectofinanciero: @informe.filtroproyectofinanciero,
        buspoa: @informe.filtropoa
      })
    end

    def informe_params
      r = params.require(:informe).permit(
        :titulo, :filtrofechaini, :filtrofechafin, 
        :filtroproyecto, 
        :filtroactividadarea, 
        :filtroproyectofinanciero, 
        :filtropoa,
        :columnanombre, :columnatipo, 
        :columnaobjetivo, :columnaproyecto, :columnapoblacion, 
        :recomendaciones, :avances, :logros, :dificultades,
        :contextointerno, :contextoexterno
      )
      return r
    end

  end
end
