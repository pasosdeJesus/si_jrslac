# encoding: UTF-8

class Factorvulnerabilidad < ActiveRecord::Base
  include Sip::Basica

  has_many :caso_factorvulnerabilidad, 
    class_name: "::CasoFactorvulnerabilidad", 
    foreign_key: "factorvulnerabilidad_id", validate: true, dependent: :destroy
  has_many :caso, class_name: "Sivel2Gen::Caso", 
    :through => :caso_factorvulnerabilidad
end
