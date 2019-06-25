# encoding: UTF-8

module Admin
  class EstadoscasoController < Sip::Admin::BasicasController
    before_action :set_estadocaso, 
      only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource  class: ::Estadocaso, except: [:create]

    def clase 
      "::Estadocaso"
    end

    def set_estadocaso
      @basica = Estadocaso.find(params[:id])
    end

    def atributos_index
      [
        :id, 
        :dominio,
        :nombre, 
        :observaciones, 
        :fechacreacion_localizada, 
        :habilitado
      ]
    end

    def genclase
      'M'
    end

    def create(registro = nil)
      # create autoriza primera, create_gen valida primero
      create_gen(registro)
    end

    def lista_params
      atributos_form - [:dominio] + [:dominio_id]
    end

    def estadocaso_params
      params.require(:estadocaso).permit(lista_params)
    end

  end
end
