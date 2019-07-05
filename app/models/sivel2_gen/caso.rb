# encoding: UTF-8

require 'sivel2_sjr/concerns/models/caso'
class Sivel2Gen::Caso < ActiveRecord::Base
  include Sivel2Sjr::Concerns::Models::Caso


  has_and_belongs_to_many :respuestafor, 
    class_name: 'Mr519Gen::Respuestafor',
    foreign_key: 'caso_id',
    association_foreign_key: 'respuestafor_id', 
    join_table: 'sivel2_gen_caso_respuestafor'
  accepts_nested_attributes_for :respuestafor, 
    allow_destroy: true, reject_if: :all_blank

  has_many :caso_factorvulnerabilidad,  validate: true,
    class_name: '::CasoFactorvulnerabilidad',
    foreign_key: 'caso_id', 
    dependent: :delete_all
  has_many :factorvulnerabilidad, 
    class_name: '::Factorvulnerabilidad',
    through: :caso_factorvulnerabilidad
  
  def rol_usuario

  end
end
