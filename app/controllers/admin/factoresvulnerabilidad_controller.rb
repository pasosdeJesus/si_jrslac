# encoding: UTF-8

module Admin
  class FactoresvulnerabilidadController < Sip::Admin::BasicasController
    before_action :set_factorvulnerabilidad, 
      only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource  class: ::Factorvulnerabilidad

    def clase 
      "::Factorvulnerabilidad"
    end

    def set_factorvulnerabilidad
      @basica = Factorvulnerabilidad.find(params[:id])
    end

    def atributos_index
      [
        "id", 
        "nombre", 
        "observaciones", 
        "fechacreacion_localizada", 
        "habilitado"
      ]
    end

    def genclase
      'M'
    end

    def factorvulnerabilidad_params
      params.require(:factorvulnerabilidad).permit(*atributos_form)
    end

  end
end
