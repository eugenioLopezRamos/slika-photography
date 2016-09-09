require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @notadmin = users(:mary)
    @admin2 = users(:peter)
    @notadmin2 = users(:daniel)
  end
  
  test "admin user logged in should get user creation page" do
    get admin_login_path
    assert_template 'sessions/new'
    post admin_login_path, params: { session: { email: @admin.email,
                                                password: 'password' } }
    get new_admin_user_path
    assert_response :success
    assert_template 'users/new'
  end
  
  test "non admin should not get user creation page" do
    get admin_login_path
    assert_template 'sessions/new'
    post admin_login_path, params: { session: { email: @notadmin.email,
                                              password: 'password' } }
    get new_admin_user_path
    assert_redirected_to admin_user_path(@notadmin)
  end

  test "admin user should be able to delete another user" do
    get admin_login_path
    assert_template 'sessions/new'
    log_in_as(@admin)
    get admin_user_path(@admin)
    assert_template 'users/show'
    assert_select 'a.all-users-link'
    get admin_users_path
    assert_template 'users/index'
    get admin_user_path(@admin)
    assert_difference 'User.count', -1 do
      delete admin_user_path(@notadmin)
    end
    assert_redirected_to admin_user_path(@admin)
  end
  
  test "non admin should not be able to delete another user" do
    get admin_login_path
    log_in_as(@notadmin)
    assert_no_difference 'User.count' do
      delete admin_user_path(@admin)
    assert_redirected_to admin_user_path(@notadmin)
    end
  end
  
  test "admin should not be able to delete another admin" do
    get admin_login_path
    log_in_as(@admin)
    assert_no_difference 'User.count' do
      delete admin_user_path(@admin2)
    end
    assert_redirected_to admin_user_path(@admin)
  end

end
