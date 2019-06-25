# encoding: UTF-8

class Estadocaso < ActiveRecord::Base
  include Sip::Basica
  belongs_to :dominio, class_name: 'Sipd::Dominio', 
    foreign_key: :dominio_id, optional: true

  @current_usuario = nil
  attr_accessor :current_usuario

  validate :dominio_usuario
  def dominio_usuario
    if current_usuario && (current_usuario.rol == Ability::ROLSUPERADMIN  ||
      current_usuario.rol == Ability::ROLDESARROLLADOR)
      return true
    end
    if !current_usuario || !self.dominio || 
      !current_usuario.dominio_ids.include?(self.dominio.id)
      errors.add(:dominio, 'Dominio debe ser uno de los del usuario')
      return false
    end
    return true
  end

end
