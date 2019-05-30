# encoding: UTF-8

class Formulariocaso < ActiveRecord::Base
  include Sip::Modelo

  belongs_to :dominio, class_name: 'Sipd::Dominio',
    foreign_key: 'dominio_id', validate: true

  has_many :pestanafc, 
    class_name: "::Pestanafc", 
    foreign_key: "formulariocaso_id", validate: true, dependent: :destroy
  accepts_nested_attributes_for :pestanafc,
    allow_destroy: true,
    reject_if: :all_blank

end
