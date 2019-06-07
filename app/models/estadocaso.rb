# encoding: UTF-8

class Estadocaso < ActiveRecord::Base
  include Sip::Basica
  belongs_to :dominio, class_name: 'Sipd::Dominio', foreign_key: :dominio_id,
    optional: true
end
