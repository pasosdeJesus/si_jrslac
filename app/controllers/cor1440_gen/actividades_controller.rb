# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < Heb412Gen::ModelosController

    include Cor1440Gen::Concerns::Controllers::ActividadesController

#    def self.filtramas(par, ac, current_usuario)
#      @buspoa = param_escapa(par, 'buspoa')
#      if @buspoa != '' then
#        ac = ac.joins(:actividad_poa).where(
#          "actividad_poa.poa_id= ?",
#          @buspoa.to_i
#        )
#      end
#      @busactividadtipo = param_escapa(par, 'busactividadtipo')
#      if @busactividadtipo != '' then
#        ac = ac.joins(:actividad_actividadtipo).where(
#          "cor1440_gen_actividad_actividadtipo.actividadtipo_id = ?",
#          @busactividadtipo.to_i
#        ) 
#      end
#      return ac
#    end
#
#    # Encabezado comun para HTML y PDF (primeras filas)
#    def encabezado_comun
#      return [ Cor1440Gen::Actividad.human_attribute_name(:id), 
#               @actividades.human_attribute_name(:fecha),
#               @actividades.human_attribute_name(:oficina),
#               @actividades.human_attribute_name(:responsable),
#               @actividades.human_attribute_name(:nombre),
#               @actividades.human_attribute_name(:actividadtipos),
#               @actividades.human_attribute_name(:actividadareas),
#               @actividades.human_attribute_name(:proyectosfinancieros),
#               @actividades.human_attribute_name(:objetivo),
#               @actividades.human_attribute_name(:poblacion)
#      ]
#    end
#
#    def fila_comun(actividad)
#      pob = actividad.actividad_rangoedadac.map { |i| 
#        (i.ml ? i.ml : 0) + (i.mr ? i.mr : 0) +
#          (i.fl ? i.fl : 0) + (i.fr ? i.fr : 0)
#      } 
#
#      return [actividad.id,
#              actividad.fecha , 
#              actividad.oficina ? actividad.oficina.nombre : "",
#              actividad.responsable ? actividad.responsable.nusuario : "",
#              actividad.nombre ? actividad.nombre : "",
#              actividad.actividadtipo.inject("") { |memo, i| 
#                (memo == "" ? "" : memo + "; ") + i.nombre },
#              actividad.actividadareas.inject("") { |memo, i| 
#                  (memo == "" ? "" : memo + "; ") + i.nombre },
#              actividad.proyectofinanciero.inject("") { |memo, i| 
#                    (memo == "" ? "" : memo + "; ") + i.nombre },
#              actividad.objetivo, 
#              pob.reduce(:+)
#      ]
#    end
#
#    def vector_a_registro(a, ac)
#      return {
#        id: a[0],
#        fecha: a[1],
#        oficina: a[2],
#        responsable: a[3],
#        nombre: a[4],
#        tipos_de_actividad: a[5],
#        areas: a[6],
#        convenios_financieros: a[7],
#        objetivo: a[8],
#        poblacion: a[9],
#        observaciones: ac.observaciones,
#        resultado: ac.resultado,
#        creacion: ac.created_at,
#        actualizacion: ac.updated_at,
#        lugar: ac.lugar,
#        corresponsables: ac.usuario.inject("") { |memo, i| 
#          (memo == "" ? "" : memo + "; ") + i.nusuario },
#      }
#    end

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
