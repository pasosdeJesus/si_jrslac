# encoding: UTF-8

require 'mr519_gen/concerns/models/respuestafor'

class Mr519Gen::Respuestafor < ActiveRecord::Base
  include Mr519Gen::Concerns::Models::Respuestafor

  has_and_belongs_to_many :caso, 
    class_name: 'Sivel2Gen::Caso', 
    foreign_key: 'respuestafor_id',
    association_foreign_key: 'caso_id',
    join_table: 'sivel2_gen_caso_respuestafor'

end
