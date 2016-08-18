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

    def completa_encabezado(enctabla)
      if @informe.columnapoa
        enctabla << "POA"
      end
    end

    def completa_fila(actividad, fila)
      if @informe.columnapoa
        fila << actividad.poa.inject("") { |memo, i| 
          (memo == "" ? "" : memo + "; ") + i.nombre }
      end
    end

    def impreso
      @informe = Informe.find(@informe.id)
      @actividades = filtra_actividades

      # Ejemplo de https://github.com/sandrods/odf-report
      report = ODFReport::Report.new("#{Rails.root}/app/reportes/Plantilla-InformeActividades.odt") do |r|
        r.add_field(:titulo, @informe.titulo)
        r.add_field(:fecha, Date.today)
        r.add_field(:numact, @actividades.size)
        r.add_table("ACTIVIDADES", @actividades) do |t|
          t.add_column(:nombreact) { |ac| "#{ac.nombre}" }
          t.add_column(:tipoact) { |ac| 
            ac.actividadtipo.inject("") { |memo, i| 
              (memo == "" ? "" : memo + "; ") + i.nombre }
          }
          t.add_column(:poaact) { |ac| 
            ac.poa.inject("") { |memo, i| 
              (memo == "" ? "" : memo + "; ") + i.nombre }
          }
          t.add_column(:pobact) { |ac| 
            pob = ac.actividad_rangoedadac.map { |i| 
              (i.ml ? i.ml : 0) + (i.mr ? i.mr : 0) +
                (i.fl ? i.fl : 0) + (i.fr ? i.fr : 0)
            } 
            pob.reduce(:+)
          }
        end
        r.add_field(:filtro, @informe.gen_descfiltro)
        r.add_field(:recomendaciones, @informe.recomendaciones)
        r.add_field(:avances, @informe.avances)
        r.add_field(:logros, @informe.logros)
        r.add_field(:dificultades, @informe.dificultades)
        r.add_field(:contextointerno, @informe.contextointerno)
        r.add_field(:contextoexterno, @informe.contextoexterno)
      end

      send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
        disposition: 'attachment',
        filename: 'InformeActividades.odt'
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
        :columnapoa,
        :recomendaciones, :avances, :logros, :dificultades,
        :contextointerno, :contextoexterno
      )
      return r
    end

  end
end
