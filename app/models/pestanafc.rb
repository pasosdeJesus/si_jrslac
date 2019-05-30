# encoding: UTF-8

class Pestanafc < ActiveRecord::Base
  include Sip::Modelo

  belongs_to :formulariocaso, class_name: '::Formulariocaso',
    foreign_key: 'formulariocaso_id', validate: true

  validates :titulo, presence: true, allow_blank: false,
    length: {maximum: 63}
  validates :parcial, presence: true, allow_blank: false,
    length: {maximum: 63}
  validates :orden, uniqueness: {scope: :formulariocaso_id,
    message: 'orden no puede repetirse'},
    numericality: { only_integer: true, greather_than: 0 }

  def presenta_nombre
    titulo
  end
end
