require 'test_helper'

class HackMembersControllerTest < ActionController::TestCase
  setup do
    @hack_member = hack_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hack_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hack_member" do
    assert_difference('HackMember.count') do
      post :create, hack_member: { comments: @hack_member.comments, contact_via: @hack_member.contact_via, email: @hack_member.email, email_issues: @hack_member.email_issues, email_ok: @hack_member.email_ok, first_name: @hack_member.first_name, group_with: @hack_member.group_with, hack_attendances_count: @hack_member.hack_attendances_count, initials: @hack_member.initials, non_hacker: @hack_member.non_hacker, surname: @hack_member.surname, tel_cell: @hack_member.tel_cell, tel_home: @hack_member.tel_home, tel_office: @hack_member.tel_office, title: @hack_member.title }
    end

    assert_redirected_to hack_member_path(assigns(:hack_member))
  end

  test "should show hack_member" do
    get :show, id: @hack_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hack_member
    assert_response :success
  end

  test "should update hack_member" do
    patch :update, id: @hack_member, hack_member: { comments: @hack_member.comments, contact_via: @hack_member.contact_via, email: @hack_member.email, email_issues: @hack_member.email_issues, email_ok: @hack_member.email_ok, first_name: @hack_member.first_name, group_with: @hack_member.group_with, hack_attendances_count: @hack_member.hack_attendances_count, initials: @hack_member.initials, non_hacker: @hack_member.non_hacker, surname: @hack_member.surname, tel_cell: @hack_member.tel_cell, tel_home: @hack_member.tel_home, tel_office: @hack_member.tel_office, title: @hack_member.title }
    assert_redirected_to hack_member_path(assigns(:hack_member))
  end

  test "should destroy hack_member" do
    assert_difference('HackMember.count', -1) do
      delete :destroy, id: @hack_member
    end

    assert_redirected_to hack_members_path
  end
end
