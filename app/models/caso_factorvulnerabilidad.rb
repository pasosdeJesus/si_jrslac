# encoding: UTF-8

class CasoFactorvulnerabilidad < ActiveRecord::Base
  belongs_to :caso, class_name: 'Sivel2Gen::Caso', 
    foreign_key: 'caso_id'
  belongs_to :factorvulnerabilidad, class_name: '::Factorvulnerabilidad',
    foreign_key: 'factorvulnerabilidad_id'
end

