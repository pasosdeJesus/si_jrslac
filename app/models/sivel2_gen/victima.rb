# encoding: UTF-8

require 'sivel2_sjr/concerns/models/victima'

class Sivel2Gen::Victima < ActiveRecord::Base
  include Sivel2Sjr::Concerns::Models::Victima

  validate :genero_valida
  def genero_valida
    cv = ::ApplicationHelper::GENERO.map {|r| r[1].to_s}
    if !cv.include?(genero)
      errors.add(:genero, 'Género no válido')
    end
  end


  validate :orientacionsexual_valida
  def orientacionsexual_valida
    cv = ::ApplicationHelper::ORIENTACIONSEXUAL.map {|r| r[1].to_s}
    if !cv.include?(orientacionsexual)
      errors.add(:orientacionsexual, 'Orientación no válida')
    end
  end

end

