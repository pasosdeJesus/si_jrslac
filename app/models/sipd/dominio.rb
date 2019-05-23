# encoding: UTF-8

require 'sipd/concerns/models/dominio'

module Sipd
  class Dominio < ActiveRecord::Base 

    include Sipd::Concerns::Models::Dominio

    has_one :formulariocaso, class_name: 'Formulariocaso',
      foreign_key: :dominio_id, validate: true
  end
end
