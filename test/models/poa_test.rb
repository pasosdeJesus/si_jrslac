# encoding: UTF-8

require_relative '../test_helper'

class PoaTest < ActiveSupport::TestCase

  PRUEBA_POA= {
    id: 1000,
    nombre: "Poa",
    fechacreacion: "2015-07-09",
    created_at: "2015-07-09"
  }

  test "valido" do
    poa = Poa.create PRUEBA_POA
    assert poa.valid?
    poa.destroy
  end

  test "no valido" do
    poa = Poa.new PRUEBA_POA
    poa.nombre = ''
    assert_not poa.valid?
    poa.destroy
  end


end
