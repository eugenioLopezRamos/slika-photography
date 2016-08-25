require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @notadmin = users(:mary)
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

end
