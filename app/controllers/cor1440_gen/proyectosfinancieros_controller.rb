# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/proyectosfinancieros_controller"

module Cor1440Gen
  class ProyectosfinancierosController < Sip::ModelosController
    include Cor1440Gen::Concerns::Controllers::ProyectosfinancierosController


    load_and_authorize_resource  class: Cor1440Gen::Proyectofinanciero,
      only: [:new, :create, :destroy, :edit, :update, :index, :show,
             :objetivospf]

    def actividadespf
      pfl = []
      if params[:pfl] && params[:pfl] != ''
        params[:pfl].each do |pf|
          pfl << pf.to_i
        end
      end
      c = Cor1440Gen::Actividadpf.where(proyectofinanciero_id: pfl)
      respond_to do |format|
        format.json {
          @registros = @registro = c.all
          render :actividadespf#, json: @registro
        }
        format.js {
          @registros = @registro = c.all
          render :actividadespf#, json: @registro
        }
      end
    end

    def new
      @registro = clase.constantize.new
      @registro.monto = 1
      @registro.nombre = 'N'
      @registro.save!
      redirect_to cor1440_gen.edit_proyectofinanciero_path(@registro)
    end

    def atributos_index
      [ "id", 
        "nombre" ] +
        [ :financiador_ids =>  [] ] +
        [ "fechainicio_localizada",
          "fechacierre_localizada",
          "responsable"
      ] +
      [ "compromisos", 
        "monto",
        "observaciones",
        "objetivopf",
        "indicadorobjetivo",
        "resultadopf",
        "indicadorpf",
        "actividadpf"
      ]
    end

  end
end
