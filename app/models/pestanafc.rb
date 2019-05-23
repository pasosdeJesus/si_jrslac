# encoding: UTF-8

class Pestanafc < ActiveRecord::Base
  include Sip::Modelo

  belongs_to :formulariocaso, class_name: '::Formulariocaso',
    foreign_key: 'formulariocaso_id', validate: true

  validates :titulo, presence: true, allow_blank: false,
    length: {maximum: 63}
  validates :parcial, presence: true, allow_blank: false,
    length: {maximum: 63}
end
