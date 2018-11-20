require 'test_helper'

class FactoresvulnerabilidadControllerTest < ActionController::TestCase
  setup do
    skip
    @factorvulnerabilidad = Factorvulnerabilidad(:one)
  end

  test "should get index" do
    skip
    get :index
    assert_response :success
    assert_not_nil assigns(:factorvulnerabilidad)
  end

  test "should get new" do
    skip
    get :new
    assert_response :success
  end

  test "should create factorvulnerabilidad" do
    skip
    assert_difference('Factorvulnerabilidad.count') do
      post :create, factorvulnerabilidad: { created_at: @factorvulnerabilidad.created_at, fechacreacion: @factorvulnerabilidad.fechacreacion, fechadeshabilitacion: @factorvulnerabilidad.fechadeshabilitacion, nombre: @factorvulnerabilidad.nombre, observaciones: @factorvulnerabilidad.observaciones, updated_at: @factorvulnerabilidad.updated_at }
    end

    assert_redirected_to factorvulnerabilidad_path(assigns(:factorvulnerabilidad))
  end

  test "should show factorvulnerabilidad" do
    skip
    get :show, id: @factorvulnerabilidad
    assert_response :success
  end

  test "should get edit" do
    skip
    get :edit, id: @factorvulnerabilidad
    assert_response :success
  end

  test "should update factorvulnerabilidad" do
    skip
    patch :update, id: @factorvulnerabilidad, factorvulnerabilidad: { created_at: @factorvulnerabilidad.created_at, fechacreacion: @factorvulnerabilidad.fechacreacion, fechadeshabilitacion: @factorvulnerabilidad.fechadeshabilitacion, nombre: @factorvulnerabilidad.nombre, observaciones: @factorvulnerabilidad.observaciones, updated_at: @factorvulnerabilidad.updated_at }
    assert_redirected_to factorvulnerabilidad_path(assigns(:factorvulnerabilidad))
  end

  test "should destroy factorvulnerabilidad" do
    skip
    assert_difference('Factorvulnerabilidad.count', -1) do
      delete :destroy, id: @factorvulnerabilidad
    end

    assert_redirected_to factorvulnerabilidades_path
  end
end
