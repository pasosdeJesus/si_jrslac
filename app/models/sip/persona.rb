# encoding: UTF-8

require 'cor1440_gen/concerns/models/persona'

module Sip
  class Persona < ActiveRecord::Base
    include Cor1440Gen::Concerns::Models::Persona

    OPCIONES_SEXO = [
      ["SIN INFORMACIÓN", :S], 
      ["MUJER", :F], 
      ["HOMBRE", :M]
    ]

    def presenta(atr)
      case atr.to_s
      when 'sexo'
        sexo == 'M' ?  
          'HOMBRE' : ( sexo == 'F' ?  
                 'MUJER' : ( sexo == 'S' ?
                           'SIN INFORMACIÓN' : sexo )
                     )
      else
        presenta_gen(atr)
      end
    end    

  end
end
