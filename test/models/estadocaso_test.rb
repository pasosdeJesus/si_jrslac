# encoding: UTF-8

require 'test_helper'

class EstadocasoTest < ActiveSupport::TestCase

  PRUEBA_ESTADOCASO = {
    nombre: "Estadocaso",
    fechacreacion: "2019-06-07",
    created_at: "2019-06-07"
  }

  test "valido" do
    Estadocaso = ::Estadocaso.create(
      PRUEBA_ESTADOCASO)
    assert(Estadocaso.valid?)
    Estadocaso.destroy
  end

  test "no valido" do
    Estadocaso = ::Estadocaso.new(
      PRUEBA_ESTADOCASO)
    Estadocaso.nombre = ''
    assert_not(Estadocaso.valid?)
    Estadocaso.destroy
  end

  test "existente" do
    skip
    Estadocaso = ::Estadocaso.where(id: 0).take
    assert_equal(Estadocaso.nombre, "SIN INFORMACIÓN")
  end

end
