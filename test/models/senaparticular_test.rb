# encoding: UTF-8

require 'test_helper'

class SenaparticularTest < ActiveSupport::TestCase

  PRUEBA_SENAPARTICULAR = {
    nombre: "Senaparticular",
    fechacreacion: "2019-06-24",
    created_at: "2019-06-24"
  }

  test "valido" do
    Senaparticular = ::Senaparticular.create(
      PRUEBA_SENAPARTICULAR)
    assert(Senaparticular.valid?)
    Senaparticular.destroy
  end

  test "no valido" do
    Senaparticular = ::Senaparticular.new(
      PRUEBA_SENAPARTICULAR)
    Senaparticular.nombre = ''
    assert_not(Senaparticular.valid?)
    Senaparticular.destroy
  end

  test "existente" do
    skip
    Senaparticular = ::Senaparticular.where(id: 0).take
    assert_equal(Senaparticular.nombre, "SIN INFORMACIÓN")
  end

end
