require 'test_helper'

class OccasionalGroupsControllerTest < ActionController::TestCase
  setup do
    @occasional_group = occasional_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:occasional_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create occasional_group" do
    assert_difference('OccasionalGroup.count') do
      post :create, occasional_group: { description: @occasional_group.description, no_of_attendees: @occasional_group.no_of_attendees, notes: @occasional_group.notes, references: @occasional_group.references }
    end

    assert_redirected_to occasional_group_path(assigns(:occasional_group))
  end

  test "should show occasional_group" do
    get :show, id: @occasional_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @occasional_group
    assert_response :success
  end

  test "should update occasional_group" do
    patch :update, id: @occasional_group, occasional_group: { description: @occasional_group.description, no_of_attendees: @occasional_group.no_of_attendees, notes: @occasional_group.notes, references: @occasional_group.references }
    assert_redirected_to occasional_group_path(assigns(:occasional_group))
  end

  test "should destroy occasional_group" do
    assert_difference('OccasionalGroup.count', -1) do
      delete :destroy, id: @occasional_group
    end

    assert_redirected_to occasional_groups_path
  end
end
