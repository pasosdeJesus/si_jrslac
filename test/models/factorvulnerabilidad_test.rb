# encoding: UTF-8

require 'test_helper'

class FactorvulnerabilidadTest < ActiveSupport::TestCase

  PRUEBA_F = {
    id: 1000,
    nombre: "Factor",
    fechacreacion: "2018-11-12",
    created_at: "2018-11-12"
  }

  test "valido" do
    f = Factorvulnerabilidad.create PRUEBA_F
    assert f.valid?
    f.destroy
  end

  test "no valido" do
    f = Factorvulnerabilidad .new PRUEBA_F
    f.nombre = ''
    assert_not f.valid?
    f.destroy
  end

end
