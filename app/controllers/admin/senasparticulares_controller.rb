# encoding: UTF-8

module Admin
  class SenasparticularesController < Sip::Admin::BasicasController
    before_action :set_senaparticular, 
      only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource  class: ::Senaparticular

    def clase 
      "::Senaparticular"
    end

    def set_senaparticular
      @basica = Senaparticular.find(params[:id])
    end

    def atributos_index
      [
        :id, 
        :nombre, 
        :observaciones, 
        :fechacreacion_localizada, 
        :habilitado
      ]
    end

    def genclase
      'F'
    end

    def senaparticular_params
      params.require(:senaparticular).permit(*atributos_form)
    end

  end
end
