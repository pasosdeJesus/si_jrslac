# encoding: UTF-8

class Poa < ActiveRecord::Base
	include Sip::Basica

  has_many :actividad_poa, dependent: :delete_all,
    class_name: '::ActividadPoa', foreign_key: 'poa_id'
  has_many :actividad, through: :actividad_poa,
    class_name: 'Cor1440Gen::Actividad'
end
