# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/proyectosfinancieros_controller"

module Cor1440Gen
  class ProyectosfinancierosController < Sip::ModelosController
    include Cor1440Gen::Concerns::Controllers::ProyectosfinancierosController

    def actividadespf
      pfl = []
      if params[:pfl] && params[:pfl] != ''
        params[:pfl].each do |pf|
          pfl << pf.to_i
        end
      end
      c = ::Actividadpf.where(proyectofinanciero_id: pfl)
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

    def atributos_index
      [ "id", 
        "nombre" ] +
        [ :financiador_ids =>  [] ] +
        [ "fechainicio_localizada",
          "fechacierre_localizada",
          "responsable_id"
      ] +
      [ "compromisos", 
        "monto",
        "observaciones"
      ] +
      [ :actividadpf_attributes =>  [
          :id, :nombrecorto, :titulo, 
          :descripcion, :_destroy ] 
      ] 

    end

  end
end
