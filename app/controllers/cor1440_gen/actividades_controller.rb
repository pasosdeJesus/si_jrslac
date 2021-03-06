# encoding: UTF-8
require_dependency "sivel2_sjr/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < Heb412Gen::ModelosController

    include Sivel2Sjr::Concerns::Controllers::ActividadesController

    before_action :set_actividad, 
      only: [:show, :edit, :update, :destroy],
      exclude: [:contar]
    load_and_authorize_resource class: Cor1440Gen::Actividad

    def self.filtramas(par, ac, current_usuario)
      @buspoa = param_escapa(par, 'buspoa')
      if @buspoa != '' then
        ac = ac.joins(:poa).where(
          "poa.id= ?", @buspoa.to_i
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
        :respuestafor,
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

    def self.posibles_nuevaresp
      return {
        ahumanitaria: ['Asistenia humanitaria', 116],
        apsicosocial: ['Asistencia psicosocial', 117],
        alegal: ['Asistencia legal', 118]
      } 
    end

    # Retorna datos por enviar a nuevo de este controlador
    # desde javascript cuando se añade una respuesta a un caso
    def self.datos_nuevaresp(caso, controller)
      return {
        nombre: "Seguimiento/Respuesta a caso #{caso.id}",
        oficina_id: caso.casosjr.oficina_id,
        caso_id: caso.id, 
        proyecto_id: 101,
        usuario_id: controller.current_usuario.id 
      } 
    end

    def self.pf_planest_id
      10
    end
    
    def self.actividadpf_segcas_id
      112
    end

    def edit
      @listadoasistencia = true
      edit_cor1440_gen
      render layout: 'application'
    end

    # No confiar parametros a Internet, sólo permitir lista blanca
    def actividad_params
      lp = lista_params_sivel2_sjr + [
        :poa_ids => []
      ]
      params.require(:actividad).permit(lp)
    end

  end
end
