require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
  end
  
  test "invalid login" do
    
  get admin_login_path
  assert_template 'admin/sessions/new'
  post admin_login_path, params: { session: { email: "", password: "" } }
  assert_template 'admin/sessions/new'
  assert_not flash.empty?
  get admin_login_path
  assert flash.empty?
  
  end
  
  test "valid login works, then logout works" do

    get admin_login_path
    assert_template 'admin/sessions/new'
    post admin_login_path, params: {session: {email: @user.email, password: 'password'}} 
    assert is_logged_in?
    assert_redirected_to admin_user_url(@user)
    follow_redirect!
    assert_template 'users/show'
    
    delete admin_logout_path
    assert_not is_logged_in?
    assert_redirected_to admin_login_path
    follow_redirect!
    assert_template 'sessions/new'
    
    #simulate logout on another window
    delete admin_logout_path
    follow_redirect!
    assert_template 'sessions/new'
  end
  
  test "login w/ remember" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  test "login w/o remember" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
end
