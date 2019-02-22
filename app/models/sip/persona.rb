# encoding: UTF-8

require 'sipd/concerns/models/persona'
require 'cor1440_gen/concerns/models/persona'
require 'sivel2_sjr/concerns/models/persona'

module Sip
  class Persona < ActiveRecord::Base 

    include Sipd::Concerns::Models::Persona
    include Cor1440Gen::Concerns::Models::Persona
    include Sivel2Sjr::Concerns::Models::Persona

  end
end
