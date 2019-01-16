# encoding: UTF-8

class Factorvulnerabilidad < ActiveRecord::Base
  include Sip::Basica

  has_and_belongs_to_many :caso, 
    class_name: "Sivel2Gen::Caso", 
    foreign_key: "factorvulnerabilidad_id", 
    validate: true, 
    association_foreign_key: 'caso_id',
    join_table: :caso_factorvulnerabilidad

end
