# encoding: UTF-8

require 'cor1440_gen/concerns/models/usuario'
require 'sivel2_sjr/concerns/models/usuario'
require 'sal7711_gen/concerns/models/usuario'

class Usuario < ActiveRecord::Base 
  include Cor1440Gen::Concerns::Models::Usuario
  include Sivel2Sjr::Concerns::Models::Usuario
  include Sal7711Gen::Concerns::Models::Usuario
end
