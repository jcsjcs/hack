require 'test_helper'

class HackMeetsControllerTest < ActionController::TestCase
  setup do
    @hack_meet = hack_meets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hack_meets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hack_meet" do
    assert_difference('HackMeet.count') do
      post :create, hack_meet: { hack_attendances_count: @hack_meet.hack_attendances_count, hack_date: @hack_meet.hack_date, hack_month: @hack_meet.hack_month, hack_venue_id: @hack_meet.hack_venue_id, hack_year: @hack_meet.hack_year, notes: @hack_meet.notes, social: @hack_meet.social, start_time: @hack_meet.start_time, work_area: @hack_meet.work_area }
    end

    assert_redirected_to hack_meet_path(assigns(:hack_meet))
  end

  test "should show hack_meet" do
    get :show, id: @hack_meet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hack_meet
    assert_response :success
  end

  test "should update hack_meet" do
    patch :update, id: @hack_meet, hack_meet: { hack_attendances_count: @hack_meet.hack_attendances_count, hack_date: @hack_meet.hack_date, hack_month: @hack_meet.hack_month, hack_venue_id: @hack_meet.hack_venue_id, hack_year: @hack_meet.hack_year, notes: @hack_meet.notes, social: @hack_meet.social, start_time: @hack_meet.start_time, work_area: @hack_meet.work_area }
    assert_redirected_to hack_meet_path(assigns(:hack_meet))
  end

  test "should destroy hack_meet" do
    assert_difference('HackMeet.count', -1) do
      delete :destroy, id: @hack_meet
    end

    assert_redirected_to hack_meets_path
  end
end
