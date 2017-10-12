# encoding: UTF-8

class Indicadorpf < ActiveRecord::Base

  belongs_to :resultadopf, 
    class_name: '::Resultadopf',
    foreign_key: 'resultadopf_id'

  validates :numero, presence: true, length: {maximum: 15}
  validates :indicador, presence:true, length: {maximum: 5000}

  def presenta_nombre
    numero + " " + indicador 
  end


end
