# encoding: UTF-8

require 'cor1440_gen/concerns/models/proyectofinanciero'

module Cor1440Gen
  class Proyectofinanciero < ActiveRecord::Base
    include Cor1440Gen::Concerns::Models::Proyectofinanciero
 
    has_many :objetivopf, foreign_key: 'proyectofinanciero_id',
      validate: true, dependent: :destroy, 
      class_name: '::Objetivopf'
    accepts_nested_attributes_for :objetivopf,
      allow_destroy: true, reject_if: :all_blank

    has_many :resultadopf, foreign_key: 'proyectofinanciero_id',
      validate: true, dependent: :destroy, 
      class_name: '::Resultadopf'
    accepts_nested_attributes_for :resultadopf,
      allow_destroy: true, reject_if: :all_blank

    has_many :indicadorpf, foreign_key: 'proyectofinanciero_id',
      validate: true, dependent: :destroy, 
      class_name: '::Indicadorpf'
    accepts_nested_attributes_for :indicadorpf,
      allow_destroy: true, reject_if: :all_blank

    has_many :actividadpf, foreign_key: 'proyectofinanciero_id',
      validate: true, dependent: :destroy, 
      class_name: '::Actividadpf'
    accepts_nested_attributes_for :actividadpf,
      allow_destroy: true, reject_if: :all_blank
  end
end
