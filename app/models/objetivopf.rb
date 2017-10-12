# encoding: UTF-8

class Objetivopf < ActiveRecord::Base
  has_many :resultadopf, dependent: :delete_all,
    class_name: '::Resultadopf', foreign_key: 'objetivopf_id'

  belongs_to :proyectofinanciero, 
    class_name: 'Cor1440Gen::Proyectofinanciero',
    foreign_key: 'proyectofinanciero_id'

  validates :numero, presence: true, length: {maximum: 15}
  validates :objetivo, presence: true, length: {maximum: 5000}

  def presenta_nombre
    numero + " " + objetivo
  end
end
