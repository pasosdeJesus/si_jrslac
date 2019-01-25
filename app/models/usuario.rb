# encoding: UTF-8

require 'cor1440_gen/concerns/models/usuario'
require 'sivel2_sjr/concerns/models/usuario'
require 'sal7711_gen/concerns/models/usuario'
require 'sipd/concerns/models/usuario'

class Usuario < ActiveRecord::Base 
  include Cor1440Gen::Concerns::Models::Usuario
  include Sivel2Sjr::Concerns::Models::Usuario
  include Sal7711Gen::Concerns::Models::Usuario
  include Sipd::Concerns::Models::Usuario


  def rol_usuario
    # limitar posibilidad de creacion de acuerdo a dominio y grupo
#    if oficina && (rol == Ability::ROLADMIN ||
#        rol == Ability::ROLINV || 
#        rol == Ability::ROLDIR)
#      errors.add(:oficina, "Oficina debe estar en blanco para el rol elegido")
#    end
#    if !oficina && rol != Ability::ROLADMIN && rol != Ability::ROLINV && 
#        rol != Ability::ROLDIR
#      errors.add(:oficina, "El rol elegido debe tener oficina")
#    end
#    if (etiqueta.count != 0 && rol != Ability::ROLINV) 
#      errors.add(:etiqueta, "El rol elegido no requiere etiquetas de compartir")
#    end
#    if (!current_usuario.nil? && current_usuario.rol == Ability::ROLCOOR)
#      if (oficina.nil? || 
#          oficina.id != current_usuario.oficina_id)
#        errors.add(:oficina, "Solo puede editar usuarios de su oficina")
#      end
#    end
  end

end
