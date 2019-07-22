# encoding: UTF-8

require 'sivel2_sjr/concerns/models/actividad'

module Cor1440Gen
  class Actividad < ActiveRecord::Base
    include Sivel2Sjr::Concerns::Models::Actividad

    has_and_belongs_to_many :poa, 
      class_name: '::Poa',
      foreign_key: 'actividad_id',
      association_foreign_key: 'poa_id',
      join_table: :actividad_poa

  end
end
