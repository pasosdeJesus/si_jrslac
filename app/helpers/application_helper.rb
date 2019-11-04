# encoding: UTF-8

module ApplicationHelper
  include Sal7711Gen::ApplicationHelper

  NIVEL_ASLEGAL=[
    ['ASESORIA', :A],
    ['MECANISMO DE EXIGIBILIDAD', :M],
    ['RESPUESTA A MECANISMO', :R]
  ]

  GENERO=[
    ['SIN INFORMACIÓN', :S],
    ['FEMENINO', :F],
    ['MASCULINO', :M]
  ]

  ORIENTACIONSEXUAL = [
        ['SIN INFORMACIÓN', :S],
        [:HETEROSEXUAL, :H], 
        [:HOMOSEXUAL, :O], 
        [:BISEXUAL, :B]
  ]

end
