# encoding: UTF-8

class FormularioscasoController < Sip::ModelosController
  helper ::ApplicationHelper

  before_action :set_formulariocaso,
    only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource class: ::Formulariocaso

  def clase
    "::Formulariocaso"
  end

  def atributos_index
    [ "id",
      "dominio_id",
      "pestanafc"
    ]
  end

  def index_reordenar(registros)
    return registros.reorder(id: :asc)
  end

  def new_modelo_path(o)
    return new_formulariocaso_path()
  end

  def genclase
    return 'M'
  end

  private

  def set_formulariocaso
    @registro = @basica = @formulariocaso = ::Formulariocaso.
      find(params[:id].to_i)
  end

  # No confiar parametros a Internet, sólo permitir lista blanca
  def formulariocaso_params
    params.require(:formulariocaso).permit(
      :id,
      :dominio_id,
      :pestanafc_attributes => [
        :id,
        :titulo,
        :orden,
        :parcial,
        :_destroy
      ]
    )
  end
end
