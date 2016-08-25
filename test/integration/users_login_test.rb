require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
#    @user = users(:michael)
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
  
 # test "valid login works" do

  #  get admin_login_path
   # assert_template 'admin/sessions/new'
   # post admin_login_path, params: {session: {email: @user.email, password: @user.password_digest}}

  # assert_template 'admin/user/[:id]'
   # follow_redirect!
# end
  
end
