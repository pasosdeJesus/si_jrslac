# encoding: UTF-8

class ActividadPoa < ActiveRecord::Base
  belongs_to :actividad, class_name: 'Cor1440Gen::Actividad', 
    foreign_key: 'actividad_id'
  belongs_to :poa, class_name: '::Poa',
    foreign_key: 'poa_id'
end

