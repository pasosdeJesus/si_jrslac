# encoding: UTF-8

require 'sivel2_sjr/concerns/models/aslegal'

module Sivel2Sjr
  class Aslegal < ActiveRecord::Base
    include Sivel2Sjr::Concerns::Models::Aslegal
 
    validates :nivel,  presence: true, allow_blank: false

    validate :nivel_valido
    def nivel_valido
      cv = ::ApplicationHelper::NIVEL_ASLEGAL.map {|r| r[1].to_s}
      if !cv.include?(nivel)
        errors.add(:nivel, 'Nivel no válido')
      end
    end

    def presenta(atr)
      case atr.to_s
      when 'nivel'
        Sip::ModeloHelper.etiqueta_coleccion(
          ::ApplicationHelper::NIVEL_ASLEGAL, nivel)
      else
        presenta_gen(atr)
      end
    end

  end
end
