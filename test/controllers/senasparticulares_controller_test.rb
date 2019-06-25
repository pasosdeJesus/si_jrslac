require 'test_helper'

class SenasparticularesControllerTest < ActionController::TestCase
  setup do
    skip
    @senaparticular = Senaparticular(:one)
  end

  test "should get index" do
    skip
    get :index
    assert_response :success
    assert_not_nil assigns(:senaparticular)
  end

  test "should get new" do
    skip
    get :new
    assert_response :success
  end

  test "should create senaparticular" do
    skip
    assert_difference('Senaparticular.count') do
      post :create, senaparticular: { created_at: @senaparticular.created_at, fechacreacion: @senaparticular.fechacreacion, fechadeshabilitacion: @senaparticular.fechadeshabilitacion, nombre: @senaparticular.nombre, observaciones: @senaparticular.observaciones, updated_at: @senaparticular.updated_at }
    end

    assert_redirected_to senaparticular_path(assigns(:senaparticular))
  end

  test "should show senaparticular" do
    skip
    get :show, id: @senaparticular
    assert_response :success
  end

  test "should get edit" do
    skip
    get :edit, id: @senaparticular
    assert_response :success
  end

  test "should update senaparticular" do
    skip
    patch :update, id: @senaparticular, senaparticular: { created_at: @senaparticular.created_at, fechacreacion: @senaparticular.fechacreacion, fechadeshabilitacion: @senaparticular.fechadeshabilitacion, nombre: @senaparticular.nombre, observaciones: @senaparticular.observaciones, updated_at: @senaparticular.updated_at }
    assert_redirected_to senaparticular_path(assigns(:senaparticular))
  end

  test "should destroy senaparticular" do
    skip
    assert_difference('Senaparticular.count', -1) do
      delete :destroy, id: @senaparticular
    end

    assert_redirected_to senasparticulares_path
  end
end
