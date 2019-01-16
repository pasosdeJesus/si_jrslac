# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < Heb412Gen::ModelosController

    include Cor1440Gen::Concerns::Controllers::ActividadesController

    def self.filtramas(par, ac, current_usuario)
      @buspoa = param_escapa(par, 'buspoa')
      if @buspoa != '' then
        ac = ac.joins(:actividad_poa).where(
          "actividad_poa.poa_id= ?",
          @buspoa.to_i
        )
      end
      @busactividadtipo = param_escapa(par, 'busactividadtipo')
      if @busactividadtipo != '' then
        ac = ac.joins(:actividad_actividadtipo).where(
          "cor1440_gen_actividad_actividadtipo.actividadtipo_id = ?",
          @busactividadtipo.to_i
        ) 
      end
      return ac
    end


    def atributos_index
      [ :id, 
        :fecha_localizada, 
        :oficina, 
        :responsable,
        :nombre, 
        :proyecto,
        :actividadareas,
        :proyectofinanciero,
        :actividadpf, 
        :objetivo,
        :poblacion,
        :anexos
      ]
    end

    def atributos_form
      atributos_show - [:id]
    end

    def atributos_show
      [ :id, 
        :nombre, 
        :fecha_localizada, 
        :lugar, 
        :oficina, 
        :proyectosfinancieros, 
        :actividadpf, 
        :poa,
        :actividadareas,
        :responsable,
        :corresponsables,
        :valorcampoact,
        :objetivo,
        :resultado,
#        :descripcion, # ven
#        :metodologia, # ven
#        :listadoasistencia,
        :poblacion,
        :observaciones,
        :anexos
      ]
    end

    # No confiar parametros a Internet, sólo permitir lista blanca
    def actividad_params
      lp = lista_params + [
        :poa_ids => []
      ]
      params.require(:actividad).permit(lp)
    end

  end
end
