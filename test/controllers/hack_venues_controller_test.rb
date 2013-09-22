require 'test_helper'

class HackVenuesControllerTest < ActionController::TestCase
  setup do
    @hack_venue = hack_venues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hack_venues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hack_venue" do
    assert_difference('HackVenue.count') do
      post :create, hack_venue: { notes: @hack_venue.notes, venue: @hack_venue.venue }
    end

    assert_redirected_to hack_venue_path(assigns(:hack_venue))
  end

  test "should show hack_venue" do
    get :show, id: @hack_venue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hack_venue
    assert_response :success
  end

  test "should update hack_venue" do
    patch :update, id: @hack_venue, hack_venue: { notes: @hack_venue.notes, venue: @hack_venue.venue }
    assert_redirected_to hack_venue_path(assigns(:hack_venue))
  end

  test "should destroy hack_venue" do
    assert_difference('HackVenue.count', -1) do
      delete :destroy, id: @hack_venue
    end

    assert_redirected_to hack_venues_path
  end
end
