# encoding: UTF-8

require 'cor1440_gen/concerns/models/informe'

module Cor1440Gen
  class Informe < ActiveRecord::Base
        include Cor1440Gen::Concerns::Models::Informe

        belongs_to :poa, class_name: '::Poa', 
          foreign_key: 'filtropoa', validate: true, optional: true

        def gen_descfiltro_post(descfiltro)
          if (poa)
            descfiltro += "Del #{Cor1440Gen::Actividad.human_attribute_name(:poa)} #{poa.nombre}.  "
          end
          return descfiltro
        end
  end
end
