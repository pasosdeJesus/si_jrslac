# encoding: UTF-8

require 'cor1440_gen/concerns/models/actividad'

module Cor1440Gen
  class Actividad < ActiveRecord::Base
    include Cor1440Gen::Concerns::Models::Actividad

    has_and_belongs_to_many :poa, 
      class_name: '::Poa',
      foreign_key: 'actividad_id',
      association_foreign_key: 'poa_id',
      join_table: :actividad_poa

  end
end
