# encoding: UTF-8

require 'sivel2_sjr/concerns/models/caso'
class Sivel2Gen::Caso < ActiveRecord::Base
  include Sivel2Sjr::Concerns::Models::Caso

  def rol_usuario

  end

  has_and_belongs_to_many :factorvulnerabilidad, 
    class_name: '::Factorvulnerabilidad',
    foreign_key: 'caso_id', 
    association_foreign_key: 'factorvulnerabilidad_id',
    join_table: :caso_factorvulnerabilidad
  
end
