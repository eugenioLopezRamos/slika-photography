require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:michael)
    @notadmin = users(:mary)
    @url = admin_users_path
  end
  
  test "valid creation info on non logged in user should fail" do
    get admin_login_path
    assert_not is_logged_in?
    assert_select 'input.submit-button'
    post admin_login_path, params: { session: { email: @admin.email,
                                                password: 'password' } }
    assert is_logged_in?
    delete admin_logout_path
    
    get new_admin_user_path
    follow_redirect!
    assert_template 'admin/sessions/new'
    assert_no_difference 'User.count' do
      post admin_users_path, params: { user: {name: "Example User",
                                              email: "user@example.com",
                                              password: "password",
                                              password_confirmation: "password"} }
      end
      follow_redirect!
      assert_template 'admin/sessions/new'
      assert_not is_logged_in?
  end
  
  test "invalid creation info" do
    get admin_login_path
    post admin_login_path params: { session: { email: @admin.email,
                                               password: 'password' } }
    get new_admin_user_path
    assert_no_difference 'User.count' do
     post admin_users_path, params:  {:user => {name: "Example User",
                                                   email: "asdx,kj@alll.s",
                                                   password: "short",
                                                   password_confirmation: "shwrt"} }
    
    end
    assert_select "div#error_explanation"
  end
  
  test "creation fails when non admin tries to create user" do
    get admin_login_path
    post admin_login_path params: { session: { email: @notadmin.email,
                                               password: 'password' } }
    get new_admin_user_path

    assert_redirected_to admin_user_path(@notadmin)
    assert_no_difference 'User.count' do
      post admin_users_path, params: { user: {name: "Example User",
                                              email: "user@example.com",
                                              password: "password",
                                              password_confirmation: "password"} }
      end
                                                   
  end
  
  test "valid creation info on logged on admin should succeed" do
    get admin_login_path
    post admin_login_path params: { session: { email: @admin.email,
                                               password: 'password' } }
    get new_admin_user_path
    assert_difference 'User.count', 1 do
      post admin_users_path, params: { user: {name: "Example User",
                                              email: "user@example.com",
                                              password: "password",
                                              password_confirmation: "password"} }
    end
  end
  
end
