# encoding: UTF-8

class Resultadopf < ActiveRecord::Base
  has_many :actividadpf, dependent: :delete_all,
    class_name: '::Actividadpf', foreign_key: 'resultadopf_id'
  has_many :indicadorpf, dependent: :delete_all,
    class_name: '::Indicadorpf', foreign_key: 'resultadopf_id'

  belongs_to :objetivopf, 
    class_name: '::Objetivopf',
    foreign_key: 'objetivopf_id'

  validates :numero, presence: true, length: {maximum: 15}
  validates :resultado, presence:true, length: {maximum: 5000}

  def presenta_nombre
    numero + " " + resultado
  end

end
