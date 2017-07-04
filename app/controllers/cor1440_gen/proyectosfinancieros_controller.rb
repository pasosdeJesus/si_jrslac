# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/proyectosfinancieros_controller"

module Cor1440Gen
  class ProyectosfinancierosController < Sip::ModelosController
    include Cor1440Gen::Concerns::Controllers::ProyectosfinancierosController

    include Sip::FormatoFechaHelper

    def index
      c = nil
      if params[:fecha] && params[:fecha] != ''
        fecha = fecha_local_estandar params[:fecha]
        c = Cor1440Gen::Proyectofinanciero.where('fechainicio <= ? AND
            ? <= fechacierre ', fecha, fecha)
      end
      super(c)
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
