require 'test_helper'

class PlantTypesControllerTest < ActionController::TestCase
  setup do
    @plant_type = plant_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plant_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plant_type" do
    assert_difference('PlantType.count') do
      post :create, plant_type: { name: @plant_type.name, notes: @plant_type.notes }
    end

    assert_redirected_to plant_type_path(assigns(:plant_type))
  end

  test "should show plant_type" do
    get :show, id: @plant_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plant_type
    assert_response :success
  end

  test "should update plant_type" do
    patch :update, id: @plant_type, plant_type: { name: @plant_type.name, notes: @plant_type.notes }
    assert_redirected_to plant_type_path(assigns(:plant_type))
  end

  test "should destroy plant_type" do
    assert_difference('PlantType.count', -1) do
      delete :destroy, id: @plant_type
    end

    assert_redirected_to plant_types_path
  end
end
