# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/informes_controller"

module Cor1440Gen
  class InformesController < ApplicationController
    include Cor1440Gen::Concerns::Controllers::InformesController
   
    def filtra_actividades
      return Cor1440Gen::ActividadesController.filtra({
        fechaini: @informe.filtrofechaini,
        fechafin: @informe.filtrofechafin,
        busarea: @informe.filtroactividadarea,
        busproyectofinanciero: @informe.filtroproyectofinanciero,
        buspoa: @informe.filtropoa
      })
    end

    def max_columnas
      10
    end

    def nombre_campo 
      return {
        'Fecha' => :fecha,
        'Responsable' => :responsable,
        'Objetivo' => :objetivo,
        'Área' => :actividadarea,
        'Población' => :actividad_rangoedadac,
        'Nombre' => :nombre,
        'Tipo de Actividad' => :actividadtipo,
        'Resultado' => :resultado,
        'Observaciones' => :observaciones,
        'Componente del POA' => :poa
      }
    end

    def otra_columna(actividad, ncol)
      if ncol == :poa
        return actividad.poa.inject("") { |memo, i| 
          (memo == "" ? "" : memo + "; ") + i.nombre }
      else 
        return nil
      end
    end

    # GET /informes/1
    def show
      @actividades = filtra_actividades
      @numactividades = @actividades.size
     

      @enctabla = []
      (1..max_columnas).each do |i|
        @enctabla << @informe['col' + i.to_s].to_s unless 
          @informe['col' + i.to_s].nil? || @informe['col' + i.to_s] == ''
      end

      @cuerpotabla = []
      @actividades.try(:each) do |actividad|
        fila = []
        (1..max_columnas).each do |i|
          unless @informe['col' + i.to_s].nil? || 
            @informe['col' + i.to_s] == ''
            nomh=@informe['col'+i.to_s]
            unless nombre_campo[nomh].nil?
              nomc=nombre_campo[nomh]
              case nomc
              when :actividadarea then
                fila << actividad.actividadareas.inject("") { 
                  |memo, i| 
                  (memo == "" ? "" : memo + "; ") + i.nombre }
              when :actividad_rangoedadac then
                pob = actividad.actividad_rangoedadac.map { |r| 
                  (r.ml ? r.ml : 0) + (r.mr ? r.mr : 0) +
                    (r.fl ? r.fl : 0) + (r.fr ? r.fr : 0)
                } 
                fila << pob.reduce(:+)
              when :actividadtipo then
                fila << actividad.actividadtipo.inject("") { |memo, r| 
                  (memo == "" ? "" : memo + "; ") + r.nombre }
              when :responsable then
                fila << (!actividad.responsable.nil? ? 
                  actividad.responsable.nusuario : '')
              else
                oc = otra_columna(actividad, nomc)
                if (oc.nil?)
                  fila << actividad[nomc]
                else
                  fila << oc
                end
              end
            end
          end
        end
        @cuerpotabla << fila
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
          t.add_column(:resultadoact) { |ac| 
            "#{ac.resultado}" 
          }
          t.add_column(:observacionesact) { |ac| "#{ac.observaciones}" }
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
        :titulo, :filtrofechaini_localizada, :filtrofechafin_localizada, 
        :filtrooficina, 
        :filtroactividadarea, 
        :filtroproyectofinanciero, 
        :filtropoa,
        :filtroresponsable,
        :col1, :col2, :col3, :col4, :col5, 
        :col6, :col7, :col8, :col9, :col10,
        :columnanombre, :columnatipo, 
        :columnaobjetivo, :columnaareaactividad, :columnapoblacion, 
        :columnapoa,
        :recomendaciones, :avances, :logros, :dificultades,
        :contextointerno, :contextoexterno
      )
      return r
    end

  end
end
