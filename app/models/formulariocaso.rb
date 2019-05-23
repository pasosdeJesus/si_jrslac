# encoding: UTF-8

class Formulariocaso < ActiveRecord::Base
  include Sip::Modelo

  belongs_to :dominio, class_name: 'Sipd::Dominio',
    foreign_key: 'dominio_id', validate: true

  has_many :pestanafc, 
    class_name: "::Pestanafc", 
    foreign_key: "formulariocaso_id", validate: true, dependent: :destroy
end
