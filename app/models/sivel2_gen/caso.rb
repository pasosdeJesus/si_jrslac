# encoding: UTF-8

require 'sivel2_sjr/concerns/models/caso'
class Sivel2Gen::Caso < ActiveRecord::Base
  include Sivel2Sjr::Concerns::Models::Caso

  def rol_usuario

  end

  has_many :caso_factorvulnerabilidad,  validate: true,
    class_name: '::CasoFactorvulnerabilidad',
    foreign_key: 'caso_id', 
    dependent: :delete_all
  has_many :factorvulnerabilidad, 
    class_name: '::Factorvulnerabilidad',
    through: :caso_factorvulnerabilidad
  
end
