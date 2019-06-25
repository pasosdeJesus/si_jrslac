# encoding: UTF-8

require 'sivel2_sjr/concerns/models/victimasjr'

class Sivel2Sjr::Victimasjr < ActiveRecord::Base
  include Sivel2Sjr::Concerns::Models::Victimasjr

  validates :apellidomaterno, length: {maximum: 100}
  validates :dependientes, :numericality => {:allow_blank => true}
  validates :descripcionsenas, length: {maximum: 1000}
  validates :nombrenooficial, length: {maximum: 100}
  validates :razon, length: {maximum: 1000}
end
