# encoding: UTF-8

class ActividadActividadpf < ActiveRecord::Base
  belongs_to :actividad, class_name: 'Cor1440Gen::Actividad', 
    foreign_key: 'actividad_id'
  belongs_to :actividadpf, class_name: '::Actividadpf',
    foreign_key: 'actividadpf_id'
end

