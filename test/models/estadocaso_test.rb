# encoding: UTF-8

require 'test_helper'

class EstadocasoTest < ActiveSupport::TestCase

  PRUEBA_ESTADOCASO = {
    nombre: "Estadocaso",
    fechacreacion: "2019-06-07",
    created_at: "2019-06-07"
  }

  # Usuario para ingresar y hacer pruebas
  PRUEBA_USUARIO = {
    nusuario: "admin",
    password: "sjrven123",
    nombre: "admin",
    descripcion: "admin",
    rol: 1,
    idioma: "es_CO",
    email: "usuario1@localhost",
    encrypted_password: '$2a$10$uMAciEcJuUXDnpelfSH6He7BxW0yBeq6VMemlWc5xEl6NZRDYVA3G',
    sign_in_count: 0,
    fechacreacion: "2014-08-05",
    fechadeshabilitacion: nil,
    oficina_id: nil
  }

  test "valido" do
    skip
    @current_usuario = ::Usuario.create(PRUEBA_USUARIO)
    # sign_in no opera con modelo talvez toca desde controlador
    sign_in @current_usuario
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
