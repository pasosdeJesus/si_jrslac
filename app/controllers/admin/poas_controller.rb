# encoding: UTF-8

module Admin
  class PoasController < Sip::Admin::BasicasController
    before_action :set_poa, 
      only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource  class: ::Poa

    def clase 
      "::Poa"
    end

    def set_poa
      @basica = Poa.find(params[:id])
    end

    def atributos_index
      [
        "id", "nombre", "observaciones", "fechacreacion", 
        "fechadeshabilitacion"
      ]
    end

    def genclase
      'M'
    end

    def poa_params
      params.require(:poa).permit(*atributos_form)
    end

  end
end
